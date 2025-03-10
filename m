Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54D9233156;
	Mon, 10 Mar 2025 17:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629441; cv=none; b=usUoICZNbsEbQ9yxHguKCjFMTco44ZRjWy53gXLcQeMjtfzBRdqn2u2jGnFm5kQFEj5RAUrgqVaeEeBSwHqzyNcaW8VdJxJReaAIfTFIMfuIjePVR4QnorTHN6TvPc77J5QlOcdWWjbjdgITCSE3ZPVrUYa2PWjknUjhL0/lelg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629441; c=relaxed/simple;
	bh=YDMx3Dx0nuZttc1dEXyQJjSbNYFrfIPWqf8i27dYM+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8w4tw9/zYxCUzL3DX7JI8u4ZV1NX1EORumLABzX9NJjYJ1AVr2MwJ7nLcCO/TVwKPKCfUAMsO/zs2diA9G+H2GOpFgH9ZAuckWGd7OuA+Aw5whgfiXfFMNgMY3UtlG1BUP8tk2kMG1/KKs4mi0dTWKLubZoZh2Vjzqak2g4ZHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrIE7VFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrIE7VFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3C5C4CEE5;
	Mon, 10 Mar 2025 17:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629440;
	bh=YDMx3Dx0nuZttc1dEXyQJjSbNYFrfIPWqf8i27dYM+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrIE7VFmSRi+L1OP5z1tu+9Y8zRNpj4CSzPVx+d6DcLB1Vgi2ofqw+8kqGnts7vaF
	 f7y6h89QSyV9ZTDZ+9Qnu032ypy51mHJtzOTMxYgIxB2M1oPHL7lGU9RdGLonLAd4D
	 oQbIKpLW8YrxxMO4HrZpvntDlq6O8MY/589gBeug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 296/620] nvme-pci: Add TUXEDO IBP Gen9 to Samsung sleep quirk
Date: Mon, 10 Mar 2025 18:02:22 +0100
Message-ID: <20250310170557.307329713@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2977,6 +2977,7 @@ static unsigned long check_vendor_combin
 		 */
 		if (dmi_match(DMI_BOARD_NAME, "DN50Z-140HC-YD") ||
 		    dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
+		    dmi_match(DMI_BOARD_NAME, "GXxMRXx") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PG31") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PRX1_PH6PRX1") ||
 		    dmi_match(DMI_BOARD_NAME, "PH6PG01_PH6PG71"))


