Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654F5318B96;
	Thu, 28 May 2026 20:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001364; cv=none; b=Kml7e4rrOiZyKg7ki6cDC0Q5BcvWcdaLGZ7yuq0tFOty3zxKTA5IaEhmP9CiYoLJidUSSn0siMha6yxtLh++799aotXTTaAJbmQpYhoVNZcgjuaErhbQTRFRsMKXHTBWpi96VbDJ7q2yk4ZT0CIG4McdVzVBwUrJohty9jD9Zxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001364; c=relaxed/simple;
	bh=jVIEdlFJXM80ORcHzQyz2JYrBZy92ze8zm+UjR2POyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMiDTZFQMpBs+qoKajw6u5pN4vCTK7DyvWZFpRDsP4C2sNDBFy10Uayb7UbZ73ahpvoan435g4M/lC7cOI47RORz3xhCbHDaD7cdhBFTxRllLlml123TyH7nKemc0NYwko7JHPc/ehiEcnYRFkHzfU++sj/lrhDlCQxtXl3KAYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZ72a0S0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZ72a0S0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7242E1F000E9;
	Thu, 28 May 2026 20:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001363;
	bh=Vqzj7HTOpIDAC7ffAI3RAkh0Y/omeVVb2HjkuSTHJ6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZ72a0S0sUwzPQDECelXrYpi/43u/lIILH/MZkzpgoPxwjX2jWzo4rmcObUqyzxln
	 7QUCQDMo2mLzD2S9TAh/10U8H0Re4zhfJqZZxdSyga+srM4eelvLhitiIAIuwn/qB/
	 EaLIpgEhRRwqVCUVViKy/fmt6f/KQfDbiRXmAq6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/186] kunit: config: Enable KUNIT_DEBUGFS by default
Date: Thu, 28 May 2026 21:49:40 +0200
Message-ID: <20260528194931.633856136@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Gow <david@davidgow.net>

[ Upstream commit 17e4c68ff35090d8cb743e3c82c09f92fda1ebda ]

The KUNIT_DEBUGFS option is currently enabled based on the value of
KUNIT_ALL_TESTS, but it really doesn't have anything to do with the set of
enabled tests, so just enable it by default anyway. In particular, this
shouldn't be only visible if KUNIT_ALL_TESTS is set, which is quite
confusing.

Link: https://lore.kernel.org/r/20260425034155.53913-1-david@davidgow.net
Fixes: beaed42c427d ("kunit: default KUNIT_* fragments to KUNIT_ALL_TESTS")
Signed-off-by: David Gow <david@davidgow.net>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/kunit/Kconfig b/lib/kunit/Kconfig
index 68a6daec0aef1..fab3458c54e4c 100644
--- a/lib/kunit/Kconfig
+++ b/lib/kunit/Kconfig
@@ -16,8 +16,8 @@ menuconfig KUNIT
 if KUNIT
 
 config KUNIT_DEBUGFS
-	bool "KUnit - Enable /sys/kernel/debug/kunit debugfs representation" if !KUNIT_ALL_TESTS
-	default KUNIT_ALL_TESTS
+	bool "KUnit - Enable /sys/kernel/debug/kunit debugfs representation"
+	default y
 	help
 	  Enable debugfs representation for kunit.  Currently this consists
 	  of /sys/kernel/debug/kunit/<test_suite>/results files for each
-- 
2.53.0



