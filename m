Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E036258ED5;
	Wed, 25 Feb 2026 01:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983681; cv=none; b=FlwNSfM6BzXLAqnOrxlkXiOKH3xFMjWMYMTuvt0X0RLpdvq3Mr9tEpMljSPXqa0HgJfwa9GabUJmzWMajajszQ8WWAjLMCp9iRYFmXYaJ3pwS3hqbj48KozkRM1rLgpwy0nr17j1E+LZhNwOIspMg+nlqaO7S4u9HRKSlrzLDcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983681; c=relaxed/simple;
	bh=QPJjOxllAs9/tj1zZ6up4sHhMJxLSAihLCaR1BvjGzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3myuu7ARab+tIQZ9J/IBF4V/dRCuBIXaEQSfewK5OER7514W2hzdwZu3vd0BU9aEhadqq8JtmsXTT6c8c4U3xDRepWzayT47JSzFqG2JvexWsR026rZb+bK0UpgLij94JzMMueBawbtjxCnmHsstjthhL9Izw93LQkkY6vkMjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4UF84or; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4UF84or"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E69AC116D0;
	Wed, 25 Feb 2026 01:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983681;
	bh=QPJjOxllAs9/tj1zZ6up4sHhMJxLSAihLCaR1BvjGzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4UF84orqrMqNFdn8GshU7xhOe0Bxn5xOdCSbCbVV69KTpHcEcwxAXBVGlZnug058
	 Db8+qF56+pmbQ3gMtEKzjmsKGtY9QHeKO9WWgo5EGYVqVsAymPMic/dsdX71VidsZK
	 wdhVuluFydzgHxHjrjLyEiCITG/MSIuYhkuUyEqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.19 765/781] ata: pata_ftide010: Fix some DMA timings
Date: Tue, 24 Feb 2026 17:24:34 -0800
Message-ID: <20260225012418.481226126@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

commit ff4a46c278ac6a4b3f39be1492a4568b6dcc6105 upstream.

The FTIDE010 has been missing some timing settings since its
inception, since the upstream OpenWrt patch was missing these.

The community has since come up with the appropriate timings.

Fixes: be4e456ed3a5 ("ata: Add driver for Faraday Technology FTIDE010")
Cc: stable@vger.kernel.org
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/pata_ftide010.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/ata/pata_ftide010.c
+++ b/drivers/ata/pata_ftide010.c
@@ -122,10 +122,10 @@ static const u8 mwdma_50_active_time[3]
 static const u8 mwdma_50_recovery_time[3] = {6, 2, 1};
 static const u8 mwdma_66_active_time[3] = {8, 3, 3};
 static const u8 mwdma_66_recovery_time[3] = {8, 2, 1};
-static const u8 udma_50_setup_time[6] = {3, 3, 2, 2, 1, 1};
+static const u8 udma_50_setup_time[6] = {3, 3, 2, 2, 1, 9};
 static const u8 udma_50_hold_time[6] = {3, 1, 1, 1, 1, 1};
-static const u8 udma_66_setup_time[7] = {4, 4, 3, 2, };
-static const u8 udma_66_hold_time[7] = {};
+static const u8 udma_66_setup_time[7] = {4, 4, 3, 2, 1, 9, 9};
+static const u8 udma_66_hold_time[7] = {4, 2, 1, 1, 1, 1, 1};
 
 /*
  * We set 66 MHz for all MWDMA modes


