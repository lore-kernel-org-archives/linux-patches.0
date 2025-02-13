Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0925C26B0B5;
	Thu, 13 Feb 2025 15:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459595; cv=none; b=p707vDjsBRG+n/Qk5Ehb0RAdNO9FF2oxgmONaF3/lfnvDe1ts4N3xmOXnFzhaIwJXKA/UQiFJam+2NVkqsXr+KPXWhjZaHX1s3sN3BzprZmHYwNTgrtwggrNSY/18/rcMGCHJTY3lI6VUIOMesmJ+FiLZn6tBWZt2DQWU4U4l+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459595; c=relaxed/simple;
	bh=zSoCbaT8+tJYMK9w+0tiZoFp63u7ZRl9gaKIDtqLEYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aakQSLZMSM0sHhYsA593ofzVzdjPRHPeK/2faQT5NRjg0fYt0Bvd5IfBXWHFw+wTwGVBP1DUVVDMyENSfqsnSoejFGdp72jsGCHNRYsp9z/GkPPBI6tSd8kapWwzMLyYzM5eCPdGBkSRFPS1U7GtsvRfnyho0jM06YvtsasrDoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+ndNpoT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+ndNpoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15404C4CED1;
	Thu, 13 Feb 2025 15:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459594;
	bh=zSoCbaT8+tJYMK9w+0tiZoFp63u7ZRl9gaKIDtqLEYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+ndNpoTtUmD2rxTeV4avjkgfbEakfG9al7tIR9Ia/f2aIlMCMcP65lca7yFpaFe7
	 mp0iX1Sf5KYRt2LDZ9jQLYwvs+9j/TWMuG9qNsldsse0bH8B/o7ZknlUzKE62Byjnw
	 qRBjrPNJXHYuKpVXCOmah0SLzeDT7Cepl8n9ds4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.13 278/443] nvme-pci: Add TUXEDO IBP Gen9 to Samsung sleep quirk
Date: Thu, 13 Feb 2025 15:27:23 +0100
Message-ID: <20250213142451.336973985@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georg Gottleuber <ggo@tuxedocomputers.com>

commit 11cb3529d18514f7d28ad2190533192aedefd761 upstream.

On the TUXEDO InfinityBook Pro Gen9 Intel, a Samsung 990 Evo NVMe leads to
a high power consumption in s2idle sleep (4 watts).

This patch applies 'Force No Simple Suspend' quirk to achieve a sleep with
a lower power consumption, typically around 1.2 watts.

Signed-off-by: Georg Gottleuber <ggo@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3150,6 +3150,7 @@ static unsigned long check_vendor_combin
 		 */
 		if (dmi_match(DMI_BOARD_NAME, "DN50Z-140HC-YD") ||
 		    dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
+		    dmi_match(DMI_BOARD_NAME, "GXxMRXx") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PG31") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PRX1_PH6PRX1") ||
 		    dmi_match(DMI_BOARD_NAME, "PH6PG01_PH6PG71"))


