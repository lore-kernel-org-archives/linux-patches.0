Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1311FFC58;
	Thu, 13 Feb 2025 14:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457924; cv=none; b=Crelbm7UkuU9bq7gDmrNfLTBCoiRsJlkF/FTrB8Mujm36XpE+cBe1Z5ynSuzmEC73ZrkfD2AtOtduw+NvoOCFnu/aP0/FJE7G2Gca3J5CRKaKJp/zBp+m5sMsJYut638fnQpWjUW1mioujpZ+PWxxZAC0lh0CrMFgl1xtUJXjKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457924; c=relaxed/simple;
	bh=pIBDqT+m+U5QodWo4xO5VtZrGOFAzD/pSYqaPg5gHl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVnqGw3m1irACtCmDrDseeVPsWmKYiTmFRYyzPkJEXdjE+gwUdiIv3aurJ2H89GD+/KeuSgmMRWLt7oe8Ux5iVZVBkD1QLy4A0mwxZDZijbmmSh9+WQpre1s5Z0rzc7z8DoLeoDKjJX/G2XDokUoB+w2hXncJhw1a40jHK6o22s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTJP5Qjl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTJP5Qjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97ADFC4CEE7;
	Thu, 13 Feb 2025 14:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457924;
	bh=pIBDqT+m+U5QodWo4xO5VtZrGOFAzD/pSYqaPg5gHl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTJP5QjlqNXJejibD0Kr9ZQqqhSmr8Pc04HcsYqyg3zRbjTsw8Qi1DVnNW4wJpmWg
	 ObAv7i74NXgV1AJtMfwVr9Jw5WKNAwz0UpckrrL27znVZ7iGh/RB+zIiVUNot+5cPn
	 u1rwVfThAs6bxBEI/O3ohhC1lvI3VzI1w8AeC3q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 252/422] nvme-pci: Add TUXEDO IBP Gen9 to Samsung sleep quirk
Date: Thu, 13 Feb 2025 15:26:41 +0100
Message-ID: <20250213142446.265982789@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2989,6 +2989,7 @@ static unsigned long check_vendor_combin
 		 */
 		if (dmi_match(DMI_BOARD_NAME, "DN50Z-140HC-YD") ||
 		    dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
+		    dmi_match(DMI_BOARD_NAME, "GXxMRXx") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PG31") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PRX1_PH6PRX1") ||
 		    dmi_match(DMI_BOARD_NAME, "PH6PG01_PH6PG71"))


