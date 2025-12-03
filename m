Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C56F366DB9;
	Wed,  3 Dec 2025 16:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779438; cv=none; b=fnMCIgMuDU+cqR5zUFTlrDoPWsOlWVpo59KKTCDZ59ycsbLLXif23dQo/uv3z62Y7SVd3NMzj0tjdkm9Sipizq3JDSZTVONCdXzb5Jv+FOWoo49s5PAdFt8c4pmCdJtzaJCtJnE7FT9F/VvGbN9yTZtmE0NdzWVuyzXUD+P4PYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779438; c=relaxed/simple;
	bh=QvMlQ5kLVN0CYOVNzOm6ZaO8zutqwdle8RmKf+XR47Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1KmU5P6vPSzn/2ay3RNgFsSBawKjiYKK5/1l40MEKllIi0yhiTCWaw+rM9RrLuNg4qg8ZFFLAIEXlxL6qCB0v639MwVkGLEZZBCWq0+z7Nt8mtg2LPyexpn9T5KcckL+E9T9JbheiDboTlEGreIWK0hTXTCL7pmSJCyK/eFMFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCtHgL5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCtHgL5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAADAC4CEF5;
	Wed,  3 Dec 2025 16:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779438;
	bh=QvMlQ5kLVN0CYOVNzOm6ZaO8zutqwdle8RmKf+XR47Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCtHgL5CwxxOdlWTsUxMWhjhbL9eDk5fy5pVFcoYOl+wwpuma1dxflrygDXbar/ZA
	 C7fnOkNOESbAvrN+jNH9lew3LnJZsXN2gPfPEn8j0ziVPg4TVaas/4L+eIBztzWpdN
	 j+LTmgpSkPo2buV+UZgT3Dc9TRT62BeYPH8cESxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 258/568] scsi: mpt3sas: Add support for 22.5 Gbps SAS link rate
Date: Wed,  3 Dec 2025 16:24:20 +0100
Message-ID: <20251203152450.169826074@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 4be7599d6b27bade41bfccca42901b917c01c30c ]

Add handling for MPI26_SAS_NEG_LINK_RATE_22_5 in
_transport_convert_phy_link_rate(). This maps the new 22.5 Gbps
negotiated rate to SAS_LINK_RATE_22_5_GBPS, to get correct PHY link
speeds.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Message-Id: <20250922095113.281484-4-ranjan.kumar@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 7d6e4fe31ceed..02c970575464c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -166,6 +166,9 @@ _transport_convert_phy_link_rate(u8 link_rate)
 	case MPI25_SAS_NEG_LINK_RATE_12_0:
 		rc = SAS_LINK_RATE_12_0_GBPS;
 		break;
+	case MPI26_SAS_NEG_LINK_RATE_22_5:
+		rc = SAS_LINK_RATE_22_5_GBPS;
+		break;
 	case MPI2_SAS_NEG_LINK_RATE_PHY_DISABLED:
 		rc = SAS_PHY_DISABLED;
 		break;
-- 
2.51.0



