Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670EF266AB
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 13:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725631145; cv=none; b=ggWVIx1yJ8d4z05YjdevIzdrcntj7fRnKytS1fCraGodtQLyw0PbnGKk2bV4mnxLoFcQ7vRCEKrReMvsi1uvfzDOWaVERBnusu1ISvwlBVGDbSgAGcPo/oeIbb5OEWleKoW8HRd7TPeZJ4v6QARShlgZJkYcep3S2Tq2F9p4z5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725631145; c=relaxed/simple;
	bh=Yg2SiHL5UWHuWV4MRkSgYN4nvKfhlicwtgVhlDV78yQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KI7vzdQlhMrrZYoNbaps8rba6mBnf5iTsGVPsYlfsLZwA7IjuYib+OafZ/OpiUIoN46eJ/n29rAb9NwTwoLTVlP7ckQDyJvW4FQb4HUJcEfi+6vTtAJNEOu/zBERGE922zLCo5JfYc0YzcZ5nYg74Fxua+7gkU4bJD5J2bW6ZGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZyP7RvBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZyP7RvBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A97BC4CEC4
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 13:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725631144;
	bh=Yg2SiHL5UWHuWV4MRkSgYN4nvKfhlicwtgVhlDV78yQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZyP7RvBPC4e/44sipGbN9h5VAHAxv/DG7sRDrAn7bcuy1czyr/qQv4rbhrHeEUAVR
	 i6F2hSGIp0zdsNNOm+85ytZzKch08AH+F9VS2bqoO2kl30nlvDZVBsEILeYPdAspNc
	 AXVE86368WVGP6YorHlSsmKiVI5LkZRIMQNa9Il7FHWTLARZ0Ga0RMaARBUdALzOZM
	 eI5Lfq7NWPFIc4esExIW4u6DY+IL2tPMxvcmik+EDhQop1NVbgEQMYgQdR7o5SEo3z
	 iBm/HVhFbXEc9as5fdQK2nYoOgI5CWXgXq0dLsbeXJbdxTzXwEn2izkvtx1T7bGoLo
	 9xqN0vdJeCWdQ==
From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>
To: patches@lists.linux.dev
Subject: [PATCH net v2] selftests: net: enable bind tests
Date: Fri,  6 Sep 2024 15:58:54 +0200
Message-ID: <20240906135853.2207882-2-matttbe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <5a009b26cf5fb1ad1512d89c61b37e2fac702323.1725430322.git.jamie.bainbridge@gmail.com>
References: <5a009b26cf5fb1ad1512d89c61b37e2fac702323.1725430322.git.jamie.bainbridge@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=709; i=matttbe@kernel.org; h=from:subject; bh=Vgq1lO9X6VemSK7hxYc8DWxMuSDgPwjNnFAy6GjPxs0=; b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBm2wqdy0MNu3jIC4L4WvKZgzhhRdVT+dvQLxy2l X4gGj/k9jmJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZtsKnQAKCRD2t4JPQmmg c1TTD/4nkWblDHqVJhFb5yv+2F2jwERvc1fuTltB2wlVafSgS1hruVHmwt5tirr2+w4xaLp9POS Pbuu+WbhkahayJ5n2HaVVC4vF4gvqWghu0QLhLxQU26Ts0o2DNVX0tPkMbiHSiPROTlzxLHOxCD bDlxZL2iEXlA5YSAi6GWrLHWsK8dE8HdrdyPWq5yjA50RGbpfrAjlFNhr+Anqkks3e7cuYMs2+5 kOZkPM1A98U0AYhqRRghxR97Q/m2T5dRzsn1Ty1WUojlPYxmD8t8hbzRyUd3wwwiB4ytHcOJN2e Rt1QAMLE+fNGc8bVHzvS4k/BM/+eemQtkstrg6/wJkTVge1KPQz7MKZjeQ9COpUZWPtb/LcVE8D kXdJF1hQWlTvZtdXQ/dVlLmYJyf8T9x9Ip4sQD2O0XGGLW90vQZSlDjFm6bYMi7xhjpGCpGG1RY rCtdaUnwyPSv1ptMjB3k8+oU2sOo8BaQnfJLY9cL2lGcnP9pK7PQeh14gk7lVZGPbiYFra03iQ5 fAGHoFG6kvdijtJiTw2CL/HSTzBfU/+ueOkLh2czUsNzSQ9UNf2IuNEaDy5VqP8fXEMTaVaYLj+ uSbunOldOkDa+2HSGLQwh2w4xs2v7qXVpB3A6CZ/be22t6fw8Owlladdo48l5kOU26iyQ2LnMU5 VUap4aCMnO5q+EQ==
X-Developer-Key: i=matttbe@kernel.org; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit

From: Jamie Bainbridge <jamie.bainbridge@gmail.com>

 ========= Please ignore, this is a test for b4 shazam =========

Link: https://lore.kernel.org/r/5a009b26cf5fb1ad1512d89c61b37e2fac702323.1725430322.git.jamie.bainbridge@gmail.com
Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 7b60eb103c5d..e1fa1b98a034 100644
--- a/Makefile
+++ b/Makefile
@@ -3,7 +3,7 @@ VERSION = 6
 PATCHLEVEL = 11
 SUBLEVEL = 0
 EXTRAVERSION = -rc5
-NAME = Baby Opossum Posse
+NAME = B4 rocks
 
 # *DOCUMENTATION*
 # To see a list of typical targets execute "make help"
-- 
2.45.2

