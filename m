Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038910;
	b=Y+7FTVIXPx4gXINBnrX5GJhCvNeZKsKc+EbDmTfs1RvwDDOrEMc2R86OUwLZPP3h/8dF
	 0H5fjX5K3wdtChrnzLrC7kctY+tJnG+imskH9COpj/kwrbpRLZkrX+dKibIkK8GRGI5Rn
	 WcUnM6aaoNP7imSMSB6D8FkbliBylaR3gWshVofRUIm1f/je+RcWdQxnmWkt9Q46wKfqK
	 WofvFODiJu3zqr08Fzfggk2DmTIcZQsnycZI5zSuqWQvmQtZ35FxMmzto7bRkz3xm9ici
	 V/hENTxd2aSbrkDBAzlaMp/Ft/XqzMUVtPbMpT7jkqqIf23pcmMo4CAWtAB/sT45cfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wpi/a85d+9GrR0oUV86gaveMBAlHJaaLOp7LMJs+hrI=;
	b=oeBeCpPi+RTZfbAVn899fjhzfuQSEG2+y3GQ4DfCg0blmshbCCnbOFsy0pP/seZExLnO
	 Bf3pmtUsMWwZ8KG0E8PmEJ7CRZgoMkTTCOte4vyRQJIDiK1smw9iAGiSEYTsSb8r7+u6w
	 swqjxdOfFUxYjsdZkH5CGLnanATyRQhTjIa3LKvu6HvvrzUSyDHJDrDGK4TZ6rmfIYjci
	 mrm3El8JQMbNwII/6R7LTWdIRXBVaC5zb5ckDfYsh1nt5DJ2FCHAGbd+tfgl34TqP6mDv
	 HZsE7AaXBdqgjdBYKLDphIA8y49tXyyylLoUL8x2YBrWFNpilq0dcF2+hClQM+BUnog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=STQTvQ2p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF556606A32F;
	Wed, 18 Nov 2026 21:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=STQTvQ2p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D650E1F000C4;
	Wed, 18 Nov 2026 21:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038910;
	bh=wpi/a85d+9GrR0oUV86gaveMBAlHJaaLOp7LMJs+hrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STQTvQ2p2/ATJXPQsgBQdKaKe22g+tnHmNM80L6H6/vnG3EdPKFFkvDAFbzKV2O7w
	 ZNvRQQINXPOg5uchQjynaws0HGxD0f61rRwv/qojvSpqsLeXBIWUTGRHqIJJtV9D9A
	 WW/Z7vQ8NmK3YTog+o7CIZaJrEKiRMRbSL360CNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aric Cyr <aric.cyr@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Krunoslav Kovac <krunoslav.kovac@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1910/3318] drm/amd/display: Send PQ bit in AMD VSIF
Date: Wed, 18 Nov 2026 15:42:12 +0100
Message-ID: <20261118150419.306488813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krunoslav Kovac <krunoslav.kovac@amd.com>

[ Upstream commit c21a764a98cb59d673cad3da64f35f4dec951951 ]

[WHY & HOW]
PB9 bit 5 was added to signal PQ EOTF in AMD vendor specific infoframe.
This change sets it when appropriate.

Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Krunoslav Kovac <krunoslav.kovac@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/freesync/freesync.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
index 803586f4267af..0a1932a7e2890 100644
--- a/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
+++ b/drivers/gpu/drm/amd/display/modules/freesync/freesync.c
@@ -698,10 +698,12 @@ static void build_vrr_infopacket_fs2_data(enum color_transfer_func app_tf,
 	if (app_tf != TRANSFER_FUNC_UNKNOWN) {
 		infopacket->valid = true;
 
-		if (app_tf != TRANSFER_FUNC_PQ2084) {
+		if (app_tf == TRANSFER_FUNC_PQ2084)
+			infopacket->sb[9] |= 0x20; // PB9 = [Bit 5 = PQ EOTF Active]
+		else {
 			infopacket->sb[6] |= 0x08;  // PB6 = [Bit 3 = Native Color Active]
 			if (app_tf == TRANSFER_FUNC_GAMMA_22)
-				infopacket->sb[9] |= 0x04;  // PB6 = [Bit 2 = Gamma 2.2 EOTF Active]
+				infopacket->sb[9] |= 0x04;  // PB9 = [Bit 2 = Gamma 2.2 EOTF Active]
 		}
 	}
 }
-- 
2.53.0



