Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123621FB3;
	Tue, 27 May 2025 17:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367969; cv=none; b=d6KmNeAkMiRW/I2pF7/4s15ztT+Gx1pEbeJSgVeDkAwPwO1wVDq4WoShkuzn97lIOZ0IWPpuydOq8W/RBl9D42vkTT/CwaDQjC2S1b2dlghGgdTUM1dhBctBaItiPVycH1CBKwu8mit61Ijy50piP6W5Ut6TSTa/vLS8qukWGA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367969; c=relaxed/simple;
	bh=3i7/8Udf2S1/feShLNz9jWT4haln+DlZYZoxG9Q6NKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liw17Oz+nEo4f/bThY4dOGJwgogNxLFO1AbO+zVT+YBOBBxgfSKjQ3P/fWZ178XuHkPP8UDh1pX1K94y6D+2EwJiSdeM7o0QCewk7j4ycdqquQ0TorF+jmGRRW89qRxDi9+Jdb4b8v2rJEoFgfcwG30oet00fbcyEThhzbtYJZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXT2jiej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXT2jiej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D6CC4CEE9;
	Tue, 27 May 2025 17:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367968;
	bh=3i7/8Udf2S1/feShLNz9jWT4haln+DlZYZoxG9Q6NKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXT2jiejhQoAQA2P/NQeMlUlYSvnMfu+hKfbuT62vBBi5kI9C3emN7tiwrBV+ECSG
	 f9ocdNK7j0223EbhXk0YP1G+w6VobtQhDt3MEb4u8R9F1ffhG7laYLDjKq64/AtLQx
	 L0nnU49UY76hIYlvjYRJrSIoC4KGx9SugzrP/kkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Depeng Shao <quic_depengs@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 557/783] media: qcom: camss: Add default case in vfe_src_pad_code
Date: Tue, 27 May 2025 18:25:54 +0200
Message-ID: <20250527162535.830819999@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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
index 95f6a1ac7eaf5..3c5811c6c028e 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -400,6 +400,10 @@ static u32 vfe_src_pad_code(struct vfe_line *line, u32 sink_code,
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



