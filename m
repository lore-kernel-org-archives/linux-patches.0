Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5822F6926;
	Fri, 17 Oct 2025 15:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713272; cv=none; b=JHN3lzrfhxOJw/ZvHsuVKf873retNyMmB8qG0DgA9nykX+JxsBY4u+RRpFMeF+GDD6K+45I/7fs1ReNtlwV/dpXkskaKVrRKFVCSwSq97SqajcudC0u/IRd12M2ApOsqTzVJRxjW1H9R/6dAUIoEfl1dGmWaOV1ltXNz1uZGmPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713272; c=relaxed/simple;
	bh=NeYhWDCdUgvgIEW3BQeWM/e4FounsGyDGQcAP0tcR5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9daD/JpjqystfPIS2EdKQbY5DlJk/UpAGmHAcAZFSu1nv+tvn8QK7BFQEdWYCNxB+u7v23Os9SgSuImXgilITyXwCAmUOfCt4hh1A3RG4SRwUbXwIteVCtVCNllHb5R57eht/o8WKFx7SKlggMeq8r8fPCwGs6krFhWFHB4zkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dgqG2mMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dgqG2mMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6FFC113D0;
	Fri, 17 Oct 2025 15:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713271;
	bh=NeYhWDCdUgvgIEW3BQeWM/e4FounsGyDGQcAP0tcR5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dgqG2mMOjZo7k8sE7SL4CGpAmKd//FhWzBJHvAofZsl5h5Krxaho1zQAvnGTKtVjk
	 k8C7TW8zKt/shAMtkn1TNbfzgxBxEsU+PJfhoTPy/u2dZI0H3UhvIAdJzxwKhP70PN
	 BdUAOgDbB0YND4OGA6EFpWGL0knibvHP237H2buc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 090/168] parisc: Remove spurious if statement from raw_copy_from_user()
Date: Fri, 17 Oct 2025 16:52:49 +0200
Message-ID: <20251017145132.342974469@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit 16794e524d310780163fdd49d0bf7fac30f8dbc8 upstream.

Accidently introduced in commit 91428ca9320e.

Signed-off-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Fixes: 91428ca9320e ("parisc: Check region is readable by user in raw_copy_from_user()")
Cc: stable@vger.kernel.org # v5.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/lib/memcpy.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/parisc/lib/memcpy.c
+++ b/arch/parisc/lib/memcpy.c
@@ -41,7 +41,6 @@ unsigned long raw_copy_from_user(void *d
 	mtsp(get_kernel_space(), SR_TEMP2);
 
 	/* Check region is user accessible */
-	if (start)
 	while (start < end) {
 		if (!prober_user(SR_TEMP1, start)) {
 			newlen = (start - (unsigned long) src);


