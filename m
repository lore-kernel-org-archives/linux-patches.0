Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3AC160783;
	Mon, 27 May 2024 19:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837388; cv=none; b=VRyMjFFIFjBAqdTEn7R3t94c381joy+hPH0BSVLbB6jR4m+GM+CJm7lBDQxKrXtUcY7tmfENZCH2WgeeSLyFTBWZ14rety62Q8jjRUAHnRgten4zA8uDXNxy6hGgXdEfM8/IjlOUPdGajFTqL+3G5Govxv5l8mYRpL8ud+UnsXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837388; c=relaxed/simple;
	bh=m1T5gtK9OdVuzj8i/VI5/lUN5kQRje37I8Kdn75su5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rv5WWf9rnHWSjlgyMpQxi6RNecWdQ1paZLn42UDpdAi5X7BEL9u/W/k/DFnhKayN9GlLNn43jS/w/g1Vk/5lgiOnXoBc9HLNYumFS0ImMzczKRjBiZMezWiyOf0Ig4SJIBuIdsxdaTMdDMmtMzIhot015VZFWjsrtNV9LDMwrd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRAJz7Ld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRAJz7Ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83918C2BBFC;
	Mon, 27 May 2024 19:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837387;
	bh=m1T5gtK9OdVuzj8i/VI5/lUN5kQRje37I8Kdn75su5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRAJz7LdHqFONxJS+99qVjW/9kbJ0inyhVm79eG11ZrRc13XvIMyHy7yL0/dZO7Lm
	 k0Re+pXK2Uz1HRW4xG4Y8SJLKHy4N0aPdR9xuI2kYx5Ts+9j5kG7dolf1ygd3b0h4e
	 TZib06CUNRr4ru3pXNIZldUiS3dqJLoFr56KidLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 404/427] selftests/damon/_damon_sysfs: check errors from nr_schemes file reads
Date: Mon, 27 May 2024 20:57:31 +0200
Message-ID: <20240527185635.217046153@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

[ Upstream commit 732b8815c079199d29b0426d9372bb098c63cdc7 ]

DAMON context staging method in _damon_sysfs.py is not checking the
returned error from nr_schemes file read.  Check it.

Link: https://lkml.kernel.org/r/20240503180318.72798-3-sj@kernel.org
Fixes: f5f0e5a2bef9 ("selftests/damon/_damon_sysfs: implement kdamonds start function")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index d23d7398a27a8..fe77d7e73a25b 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -287,6 +287,8 @@ class DamonCtx:
         nr_schemes_file = os.path.join(
                 self.sysfs_dir(), 'schemes', 'nr_schemes')
         content, err = read_file(nr_schemes_file)
+        if err is not None:
+            return err
         if int(content) != len(self.schemes):
             err = write_file(nr_schemes_file, '%d' % len(self.schemes))
             if err != None:
-- 
2.43.0



