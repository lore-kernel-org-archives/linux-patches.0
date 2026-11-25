Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620128;
	b=AhMNAdOkUIJngAyT1hHSTi1ZNdXomJaMLNa5q5K2Ij8u9qhA+NLJ6W/6p8Jdko0SSq1z
	 /W7ouI7FKRuH8XJZxiB2BDufyFeq2P/2o9/1cIKRR2b2/kQ48JYhLY3VYO4qWMIPQ/1Va
	 +0Q3SrdqpbVmOCp2qhT0ZditpUDecgDHOUGrBwpsswC+I3K4ux3SG2jvm+LEuO+c0zzr9
	 99SUd/xQhCoqlooTRRGhrvjhKLz5fRGBp6aw4i6w8uGeQMr/zVySU+cwMgUnEDc5qNxYk
	 yQdah7nnwOcbsXxTBI/85+X6EBzyX1xiGjyv3i5EoHeVwnUmfmnP6MCmDQtGn4zd/OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MEcfPVYLts5sYQBHGgS8AoVjVNnfSx7ttblkXHqTdTw=;
	b=jSWHGL24AGTWrKQwTcSZmlGZLGp/4PU6M03BTE8ziWOE8bu1xZX2vbPFqXnsKL++dEuV
	 M/h/WXDwoiEs6bzLmo8XpnPH55Kfc5vHQZdVRNut/rAttBk8w+Ul9/dLatJxyxYfVKvao
	 Dct4N18UjZbNZAQzltgx8aA5hTW+KR8oKVeWsdkdT2GGFhjHusSUuP6NX/vmqmPTaaYUf
	 fSo+krutGaRKmgiXmacPEcW9QkgUu9jYJ7+tF29jl82yx4XiOznb3naqoyg8XrQ5VN2cP
	 mc200Xx2PV0ibDlCJdr1nCLnvqFu5/lDHEq1r2DQOcLyqfnSc5Fn4mm787WpeZaPWDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVTaY07V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D37A606A31E;
	Wed, 25 Nov 2026 15:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVTaY07V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F571F000C4;
	Wed, 25 Nov 2026 15:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620128;
	bh=MEcfPVYLts5sYQBHGgS8AoVjVNnfSx7ttblkXHqTdTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVTaY07VApI9hDAxWGQKJzZfbGaZG+97szFppaIEkCFFqAcXfsedIHjtPGqipp07V
	 OfNA/pcpXrdmgcR0Wdiz7fJN8gSfts+NW1YUIlj0XQ7PoCwtxB/LFwc3/maYRQSe3O
	 LeRcdoi3KgfP5QqfHmcHdDK/u3Uf4MiwP7RTiAgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Benoit Masson <yahoo@perenite.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 7.3 0791/1005] wifi: ath12k: assign device id from the WSI index
Date: Wed, 25 Nov 2026 15:35:29 +0100
Message-ID: <20261125143840.268175808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benoit Masson <yahoo@perenite.com>

commit 81986a81f09fae73926c7c44863b335880269c90 upstream.

Devices of a hardware group are added to ag->ab[] in PCI probe
completion order (ab->device_id = ag->num_probed++), which is not
stable across boots. The wiphy radio array is built from ag->ab[] and
the wiphy device is taken from its first entry, so the wiphy sysfs
path and the mapping of radio indices to bands change on every boot.

Persisted wireless configurations reference radios by index (e.g.
OpenWrt/hostapd "radio0"), so such a configuration attaches to a
random band at each boot. This affects any multi-chip group with
single-band radios, e.g. TP-Link Archer BE800 (three QCN9274/QCN9224
radios in one group).

Store each ab in ag->ab[] at its wsi_info.index, which is derived from
the device tree WSI ring and is therefore deterministic.
ag->num_probed remains the group device counter. The unassign path is
unchanged, it already indexes ag->ab[] by ab->device_id.

Suggested-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Fixes: 6f245ea0ec6c ("wifi: ath12k: introduce device group abstraction")
Cc: stable@vger.kernel.org # 6.14+
Signed-off-by: Benoit Masson <yahoo@perenite.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260928213322.98949-1-yahoo@perenite.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -2007,7 +2007,8 @@ exit:
 		goto invalid_group;
 	}
 
-	ab->device_id = ag->num_probed++;
+	ag->num_probed++;
+	ab->device_id = wsi->index;
 	ag->ab[ab->device_id] = ab;
 	ab->ag = ag;
 


