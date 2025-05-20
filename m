Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889892512C6;
	Tue, 20 May 2025 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750674; cv=none; b=oGWJcADaT0Thr8A1C8EezxGOL6+mtdP44oIJkIZuMojzMey2cZH+7jJY8YN41mRRORJLmdB+K7AoKe0HJrKjSgkAEvYRK63eqGxIarUrWMONaOSbu0DRVvJ2wEKHAO9T38tH+wyr5IDhvDrHT+iBOgFKT4+3OUjSGWemOWl5tgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750674; c=relaxed/simple;
	bh=dPrpKq5KmT6AFVggzuJhnLd/i5WPJFN1ccI+gh/jznk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMHpCeiQd+VKSmAzDzeRENV1e29seoycVt1ajPRBQepLgq+sbT4exJbBY3hsIBqayya4cSvt9cM700Sy/noVYe94Gq8F9gVuwe8phBo82TtUwNBp1O6Rdxus/ntrBiKaj8gjTu/UllHIkFuc9wGnMdRgFVNZ0JQ0c9up4oZn9Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ToS71D27; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ToS71D27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C9AC4CEE9;
	Tue, 20 May 2025 14:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750674;
	bh=dPrpKq5KmT6AFVggzuJhnLd/i5WPJFN1ccI+gh/jznk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ToS71D27wbxOhA1714/x+CZoHvAhwk4nKWJ5pZ3U5EPLedT253FgMOdbhkWi+uPvP
	 Sv4tMzkW+41Ae8OD25vVJvMO6SCHYgq+4JgamdkDEfwcOHNUJ0jTYuTWgd2dcLqP/c
	 t3Ou8XX+6zo97HHZSiDIL0WC9IvW75rzaeThsIsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
	Juergen Gross <jgross@suse.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.14 085/145] MAINTAINERS: Update Alexey Makhalovs email address
Date: Tue, 20 May 2025 15:50:55 +0200
Message-ID: <20250520125813.904989638@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Makhalov <alexey.makhalov@broadcom.com>

commit 386cd3dcfd63491619b4034b818737fc0219e128 upstream.

Fix a typo in an email address.

Closes: https://lore.kernel.org/all/20240925-rational-succinct-vulture-cca9fb@lemur/T/
Reported-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Reported-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Alexey Makhalov <alexey.makhalov@broadcom.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/20250318004031.2703923-1-alexey.makhalov@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17954,7 +17954,7 @@ F:	include/uapi/linux/ppdev.h
 PARAVIRT_OPS INTERFACE
 M:	Juergen Gross <jgross@suse.com>
 R:	Ajay Kaher <ajay.kaher@broadcom.com>
-R:	Alexey Makhalov <alexey.amakhalov@broadcom.com>
+R:	Alexey Makhalov <alexey.makhalov@broadcom.com>
 R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	virtualization@lists.linux.dev
 L:	x86@kernel.org
@@ -25350,7 +25350,7 @@ F:	drivers/misc/vmw_balloon.c
 
 VMWARE HYPERVISOR INTERFACE
 M:	Ajay Kaher <ajay.kaher@broadcom.com>
-M:	Alexey Makhalov <alexey.amakhalov@broadcom.com>
+M:	Alexey Makhalov <alexey.makhalov@broadcom.com>
 R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	virtualization@lists.linux.dev
 L:	x86@kernel.org
@@ -25378,7 +25378,7 @@ F:	drivers/scsi/vmw_pvscsi.h
 VMWARE VIRTUAL PTP CLOCK DRIVER
 M:	Nick Shi <nick.shi@broadcom.com>
 R:	Ajay Kaher <ajay.kaher@broadcom.com>
-R:	Alexey Makhalov <alexey.amakhalov@broadcom.com>
+R:	Alexey Makhalov <alexey.makhalov@broadcom.com>
 R:	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
 L:	netdev@vger.kernel.org
 S:	Supported


