Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F7414BF8D
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 13:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725630843; cv=none; b=cH+BYLUjXFatlAf3/Ul0tkdFycE7LSlrihcuVTqxEzSmvnsi9cp7+ewEaoHS17Qqu/lofG88sQu/uEQ/bzcwwwY2uTFI4c6X6VqPYLiV7Da2Ac2cuv8GZx6qZ1R6ih/lMvSmx947JqvKwZcLF7kSY8cDu9U4bC+X1cSzSNs81Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725630843; c=relaxed/simple;
	bh=Yg2SiHL5UWHuWV4MRkSgYN4nvKfhlicwtgVhlDV78yQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQq7VM/hSw6dUfdwWSmRebGyTg9sv88oqlyffMTW2mcaEKBr8d0VPdZ9CwSO8NBiBvFBuasqH8vr89v3H0qbNFriCo+leGVblbq5VVtds2Y26A2rpfoI27ebtWZCzMXz/uT6z3jZVGYecTwAmb4FxTTCpHI12kK3a14ZNV6Baw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CCdkt4S4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CCdkt4S4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34D2C4CEC4
	for <patches@lists.linux.dev>; Fri,  6 Sep 2024 13:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725630842;
	bh=Yg2SiHL5UWHuWV4MRkSgYN4nvKfhlicwtgVhlDV78yQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CCdkt4S4GITV2znb0B4YFfUZoAmkGToOtk02bm3mXPPGCC2G3kJYogP1daTwImBeg
	 FuNrjIUTY2Tgn8O9fTuOqR/UrtTqpP1dZ+d8/UUgNk9sMzVRwtAGSJ0YqnzNEoNd6h
	 I+dGx547OOUAwDgfh9WEVO9d/rEAEKUCHw2Z7Wma3wxri7dEWo6U6fWns6m/4CuK49
	 twol2pdLRAwuYhJqZoUzAOfUiHq74S7wrIASY1yrihnFozMSidvW/92V2VyFhbhnN/
	 6CgH5mBlmTk9CyzbuZvMewJ53+OxpApXPVyZewKio48bjzq9/uwfsorGFRR7STPj/u
	 grT7dxQxhlTUA==
From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>
To: patches@lists.linux.dev
Subject: [PATCH net] selftests: net: enable bind tests
Date: Fri,  6 Sep 2024 15:53:51 +0200
Message-ID: <20240906135350.2201353-2-matttbe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <5a009b26cf5fb1ad1512d89c61b37e2fac702323.1725430322.git.jamie.bainbridge@gmail.com>
References: <5a009b26cf5fb1ad1512d89c61b37e2fac702323.1725430322.git.jamie.bainbridge@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=709; i=matttbe@kernel.org; h=from:subject; bh=Vgq1lO9X6VemSK7hxYc8DWxMuSDgPwjNnFAy6GjPxs0=; b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBm2wluy0MNu3jIC4L4WvKZgzhhRdVT+dvQLxy2l X4gGj/k9jmJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZtsJbgAKCRD2t4JPQmmg c0OgEADYsc0sO/U1fs0UPIR2Nf4uRa9+/ttjXQar0sJWwZj/hP5dfstEbN0o1zl6g4KnQYsp46J AIsIUbOL87j8xxv0VA8QCsf49M5jde6tBDOgvnIJps6lmKi7AyypMyhivnv2HT8SGCVXR3vMeO9 mazntbuDPXZQyvjYWQKUmo4cXmJ265BWmCNcImWFvvm9GkoeKKjMkJJ7mudKn2vbOJUjjoeREER WspoQ1bMHmSX+8o8y4fnTzBtr3jirVZnpln2xqtdixM0t4SISVNTnC6W1ABoPt1p5njGrFtlIFE L+YesNfumEZ8k5vjpUufpqaI8Ejv4di3cTOFT2Avt9nlVV+Mu54hdA9NC8PAd3mtC8BD2P4v/7/ Ag1GOK4m6vKQFBmZl13nl5pD19qBS1DSSf8k2AGePu7Q3XClk1Z4SYKbEYYjvDuFqCficuUPIwZ 0Sy4cm6Hp/j7zCOA3f2Lbv9jdueY84SC28d85hRZ0ZMsfkmRFW3QJruuz/PlqBjfLrdvD41V3Wj FJv4+oT9rEr1ZUHiGJaiMPxrm06AfgdqvMwT2t/jb9g+gniytenFwuEYGk2kI9+FCn1GBCKNUP0 ZWtg5eFucncwxG9ruQnfo1m6tDxi2gyjt9kYEWoSytP98FUjXXlZrNkENZRj0BDZdjwcOXrjv9+ /MsGy09AOEyqH7A==
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

