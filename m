Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D9226B0B1;
	Thu, 13 Feb 2025 15:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460609; cv=none; b=YSj/OFhepQL9Jb92LobXEdM8LsIv8Mah452sBc8f1R0ZhDIjvvFpTb3VckHEorGzcvq1AX8GBF/THDEYKpxJasxW82bDKqKJGLi7Ar+rn8Fv3nQRfzwc3IBe84MNGRsnnuukdSZChNfmEy3GiS5iv0/BM/W/sIQ1adfTcsbLngU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460609; c=relaxed/simple;
	bh=Nb21F7AcfNAsCuUkuYr25FyOsItD4sfSwll8WwDa578=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k4U0Kx8+olizSZj9EuoqN89t5on7xvGy0aMb2hh1FiYlEr2440Upg7UrfEjNCQS/tS1GiU49o3cYle8BImyZLSSHGzXqqeeeGH2Ac8FQEbJr5cLOaGOPKAHJmAeRMPAeEYGg3IInpcRWpvxD55JqGxG2UkxAmK2ABbhB8X/n/fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtZkrWqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtZkrWqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB68AC4CED1;
	Thu, 13 Feb 2025 15:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460609;
	bh=Nb21F7AcfNAsCuUkuYr25FyOsItD4sfSwll8WwDa578=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtZkrWqvxDuWYxQk0k3T/vPLRDUx0dKPQxJb67uGT+0gAeq823jYyjRoy9x24TxLI
	 LkPtIEwUjRNElBX3F6vEh6JNfRQNuaI2ejKaDJof/5aRRLRdTd3bshvJbUR0J7uco5
	 dXnqWFojTcznu8n+XEeP8WrwY/V6AULFBG6qgc44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 161/273] nvme-pci: Add TUXEDO IBP Gen9 to Samsung sleep quirk
Date: Thu, 13 Feb 2025 15:28:53 +0100
Message-ID: <20250213142413.697607020@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2951,6 +2951,7 @@ static unsigned long check_vendor_combin
 		 */
 		if (dmi_match(DMI_BOARD_NAME, "DN50Z-140HC-YD") ||
 		    dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
+		    dmi_match(DMI_BOARD_NAME, "GXxMRXx") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PG31") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PRX1_PH6PRX1") ||
 		    dmi_match(DMI_BOARD_NAME, "PH6PG01_PH6PG71"))


