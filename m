Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293CA2798F8;
	Tue, 27 May 2025 17:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365768; cv=none; b=EmNUpz7TgbmNWayDWRf/YifKMziA4CHPxmXCNb3FSCC2ST7U3c2kCsU9zTE1W7+i00CkLh0LtVPiHgSMpeyjhh55fJq//xxrRbvXzbuB4owW6AeF3y20uBQdt75ouZQ/48juveJQKNDXijWePeqr5vUnT9di60+LYN3B5eZl3AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365768; c=relaxed/simple;
	bh=kvm5lYIkQKiY3ZtJE5Eepo1foCK1QvYyuUI5Of9Vvmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNofG11dzNdq69VCdJeKOaiRxPWvh4xD03c1J4p62EkiWQsaDXhKTDI6gq59YknKt/O+57YUfhMDxDGt2u5WJ9f2h3bMW5eocTAKMO/zE9cGQvyhrNvYHgVZLEvElgv9YSQp6mjZgk//Bu3+Ke0DD8IGQOC9RutiMDXqgRg2KA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/FLPqM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/FLPqM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2FAC4CEE9;
	Tue, 27 May 2025 17:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365768;
	bh=kvm5lYIkQKiY3ZtJE5Eepo1foCK1QvYyuUI5Of9Vvmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/FLPqM/yG7zkLpQ70f9RS8+Sp42RdhPPSw8eonJVVBl0clVB0PQJOwJb5MPRVKxm
	 hjUnPSTr4B1WFAXVUBS/8GbRELw/xU/sFfXdXlkGHfJrte0Tf5UFanQrM2xFRtBs2b
	 9NCEwi5cxgmxPSMBhNuglpuCxOW52C9foQhqMn8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Depeng Shao <quic_depengs@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 442/626] media: qcom: camss: Add default case in vfe_src_pad_code
Date: Tue, 27 May 2025 18:25:35 +0200
Message-ID: <20250527162502.962688603@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Depeng Shao <quic_depengs@quicinc.com>

[ Upstream commit 2f4204bb00b32eca3391a468d3b37e87feb96fa9 ]

Add a default case in vfe_src_pad_code to get rid of a compile
warning if a new hw enum is added.

Signed-off-by: Depeng Shao <quic_depengs@quicinc.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-vfe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 83c5a36d071fc..8f6b0eccefb48 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -398,6 +398,10 @@ static u32 vfe_src_pad_code(struct vfe_line *line, u32 sink_code,
 			return sink_code;
 		}
 		break;
+	default:
+		WARN(1, "Unsupported HW version: %x\n",
+		     vfe->camss->res->version);
+		break;
 	}
 	return 0;
 }
-- 
2.39.5



