Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210F23EF644;
	Tue, 21 Jul 2026 17:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653958; cv=none; b=FvzZoSBo6ar0Xec0wdXEaLZPYuoHWxqd2ZN5k5/2CR1dC6Au7vSHt7gVFpUMe9LaRi40Zcb0j1yXyJJAHzVdrWiQkogBogDWHqYNlGEZJz9FLN/pr/Mh7zXynRMmjT7MYLo1QHGCliqmyfQ5T4+dMAYPL4RyVMkCr8org7D+Q38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653958; c=relaxed/simple;
	bh=uvZte7XzGfvo+LoF3PNlbghdatkNXs3STxrvV5C67CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEGWTAgP+2lvZs1NV9jpp5ReIxtpvGO/2aJwa08JPEQDUqGWv+4QjvEO5f2VdstfOpniAXNizDOAEeIrhYqUyx39cCa3v0f/+ra+11rAeyUl26YWFG8hc+G/g/W/TzB2HO9f6wGnkJvi9Q9igTyl+GvVMibt7YrDkplh9kLHhyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dkjJD8i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dkjJD8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826B01F000E9;
	Tue, 21 Jul 2026 17:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653957;
	bh=32B9zR8cOakCctlPIJwnjXYM+VFVUgMku3TIaTCfWIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1dkjJD8iZ+FRkjYCRv8vvCwoNMzkKckDCWbd9McGTSxPp6PSP71aokENp7xnSn+7B
	 09XYq8jvJLpYG5zUgSF8EB3YBEdktELE5Bq3T2bO52sVEVchxZIvPUr4XKpaC7LU9e
	 w4/i0InoDA1GJMHTryIAte1muoMjyhbXO0+pUjt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cihan Karadag <cihan.cihan@gmail.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1480/2077] selftests: gpio: add gpio-cdev-uaf to .gitignore
Date: Tue, 21 Jul 2026 17:19:13 +0200
Message-ID: <20260721152627.709275464@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cihan Karadag <cihan.cihan@gmail.com>

[ Upstream commit 4ad805f0e41acf56ac54855c666d34c59ad66fe7 ]

Commit c7f92042d3f3 ("selftests: gpio: Add gpio-cdev-uaf tests") added
the gpio-cdev-uaf binary to TEST_GEN_PROGS_EXTENDED but never added it
to .gitignore. Building it with:

    make -C tools/testing/selftests/gpio TARGETS=gpio

leaves gpio-cdev-uaf as an untracked file.

Fixes: c7f92042d3f3 ("selftests: gpio: Add gpio-cdev-uaf tests")
Signed-off-by: Cihan Karadag <cihan.cihan@gmail.com>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260707235707.1349969-1-cihan.cihan@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/gpio/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/gpio/.gitignore b/tools/testing/selftests/gpio/.gitignore
index ededb077a3a69c..16f74de479f176 100644
--- a/tools/testing/selftests/gpio/.gitignore
+++ b/tools/testing/selftests/gpio/.gitignore
@@ -2,3 +2,4 @@
 gpio-mockup-cdev
 gpio-chip-info
 gpio-line-name
+gpio-cdev-uaf
-- 
2.53.0



