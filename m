Received: from mailly.debian.org (mailly.debian.org [82.195.75.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DAB16DEB5
	for <patches@lists.linux.dev>; Thu, 24 Oct 2024 04:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729744582; cv=none; b=HWnYUmqIVk1PH1hz8hI/8qeYbV0ZVe4Sd+luK76tupE+8u6R3QDseDel4Lkqw26KC6rp3nBseVncq0VkNiG5fkMhBp6dxhRoD6WD/x2WdN2yhKfu+JcBSofLM7N+4A4kibcYnd99s0ji9TheDeRcF4k7JtKgsa3jls3tngQN1es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729744582; c=relaxed/simple;
	bh=zKmOY6KmoQOXrSZE5fkbj3rIDiuSG4hehuJpyaIaqKM=;
	h=Content-Type:MIME-Version:Subject:From:To:Date:Message-ID; b=VNAIwlRjsbLbyHN8JgMmqURxgq385QMouIhgQgXQFfOZmRJs70ndbv/EMUxFJ74Pk05antxZzcpiJ9+0IMMKoc4oGsiPvDOyETpWjwSK2XnlSoP/PW1/Q4NTu1X7umpCj17lE18vpmv0yowTtukHSHqZcWU0NfpdoWvSEgeHnUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tracker.debian.org; spf=none smtp.mailfrom=tracker.debian.org; dkim=pass (2048-bit key) header.d=tracker.debian.org header.i=@tracker.debian.org header.b=KL3jLizj; arc=none smtp.client-ip=82.195.75.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tracker.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=tracker.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tracker.debian.org header.i=@tracker.debian.org header.b="KL3jLizj"
Received: from ticharich.debian.org ([2607:f8f0:614:1::1274:64]:59242)
	from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=ticharich.debian.org,EMAIL=hostmaster@ticharich.debian.org (verified)
	by mailly.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <noreply@tracker.debian.org>)
	id 1t3pa0-0046C1-KW
	for patches@lists.linux.dev; Thu, 24 Oct 2024 04:36:12 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=tracker.debian.org; s=smtpauto.ticharich; h=Message-ID:Date:To:From:Subject
	:Content-Transfer-Encoding:MIME-Version:Content-Type:Reply-To:Cc:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=zKmOY6KmoQOXrSZE5fkbj3rIDiuSG4hehuJpyaIaqKM=; b=KL3jLizjbVWRo4ME5hQLrTuWmx
	mLVjmlo6C+5SjfWHyR3yzXEyKI/udLnD1j/4Jc2WLPnypNeJhEe4xt5vKZK235hhvdwySjET+1BLu
	cvEnvT39Q+ROg3ZTYTyHFvjfEFCWc2VNDOdw9u0cfUYAfPJ1zVcX7d4UychBc32hBCZUP7/MXxMuy
	cSarzE92Nd8fDRbRuv607BeOYb+2LumvLSFTxl+bTzqTGEf5MZMUhhuqJKNC9+G5qzSKFh1r7nr7m
	yixYVEMM9p2VqjMoUjLBhkIlJJAhcopwGUqqasgnI9g5Uc5SfWEUrkEVI62a+p9xQheZbJ2lr4xeJ
	3dpMlG3Q==;
Received: from localhost ([::1]:53744 helo=ticharich.debian.org)
	by ticharich.debian.org with esmtp (Exim 4.94.2)
	(envelope-from <noreply@tracker.debian.org>)
	id 1t3pZy-000qcz-Td
	for patches@lists.linux.dev; Thu, 24 Oct 2024 04:36:10 +0000
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Debian Package Tracker Registration Confirmation
From: noreply@tracker.debian.org
To: patches@lists.linux.dev
Date: Thu, 24 Oct 2024 04:36:10 -0000
Message-ID: <172974457091.202074.1127832324616384562@ticharich.debian.org>

You have registered to the Debian Package Tracker.

In order to complete your registration, you must confirm that you are the
owner of this email address by going to the following URL:

https://tracker.debian.org/accounts/confirm/c9e1e7b5efcfe0bfcb323ae0f5f8ba028af12044

If you don't understand why you got this mail, please ignore it,
nothing will be done unless you follow the given link.

If you have any problem with this service, please contact
owner@tracker.debian.org.

Thanks,
--
Debian Package Tracker
https://tracker.debian.org
