Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015300;
	b=JuET2FbjsD7//mT9XRFgBEtxgmRsS/SDro0I4kfZeVzbCpGH7mNi2/N8urZwSLtSsOK8
	 iOzB9asIjRC7NX68IzgDtgFC6RRzYE3Oo+Z2rH4Bttl76wwiNR72/xsLdqWIrdYtu+Odm
	 9EKLia77h7JvKwnPRR00OsXFFrM65R28gcO3E3tIndR5eaieleDlnb6847adxn5KI/wL9
	 jxrToM3rr4xql3got3CmkjucthTG8RAkUHdvDm+8Pi031c/b1jCLnCWmDOCZaEq1Hay/1
	 4x82Nsd3e/ZMiccss+MNLhPad1DIz8DDbCxDnWI3tE8Qsd7sXqzCXcnZNLmOXLwWczw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Ni3SU2w748Jw6L4T85x1sWJvhtRajbSmYFgtDV+15M=;
	b=eoGFTNPrzyCGMEwjNeu/1W1e4DYM0OWEeo8J/tqYcCUlL0EgUoEIY4AnFeN7U0oYzMq1
	 fEpdG6xC/6Drx4YYxcjR8Z2C7wYuuH8wjsQCrudezbeiX8tgWhttmI4f5K5UgoaR8BOp1
	 4oNuzRuAViR+q4EOnzQlXVXmrd9STRSoqjyhPbmw7P8tNkJ0Q64xprzXqEcYxaCXycMxn
	 4Bik7HKEKRm5qAHLnAQlPRoL1aBi83UqKDK+P/OHGceVBdco/ftCYIms+rOvv/Iaw8Bou
	 AGJXjQ4Wynk3FT2iYFd0k7lF/YRTO5JlmKzGIypLTxV+39+PIQNaqnkX5skHClG5/iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1mUL7d4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A7D606A325;
	Wed, 18 Nov 2026 15:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g1mUL7d4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43891F000C5;
	Wed, 18 Nov 2026 15:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015300;
	bh=0Ni3SU2w748Jw6L4T85x1sWJvhtRajbSmYFgtDV+15M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g1mUL7d446hg1Y7Zs983+UW+q4L7yTI9AbJAqoMNuMVRF5Qc7MbSuw4vCXGwgJsa0
	 0LgSoOR5txyu/4IyoRXvgCw+9fiVkUSk8a3BC0jkMkTR8EuLUpt3D+pqb5afgje7eG
	 DKeJraU9Kx0qesMyGqzrrm3J/ei6Lvlu/V5tVqcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0125/2651] soc: qcom: smem: fix 32-bit overflow in DDR frequency calculation
Date: Wed, 18 Nov 2026 15:22:45 +0100
Message-ID: <20261118150252.361663402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>

[ Upstream commit 7bb5f186784074f2a91d83e191e305238be47103 ]

The DDR frequency in SMEM is reported in kHz and converted to Hz by
multiplying it by 1000. Since the SMEM frequency value is a u32, using
an unsuffixed integer constant causes the multiplication to be performed
with 32-bit arithmetic.

This overflows for DDR frequencies above 4294967 kHz, resulting in an
incorrect frequency being reported through the SMEM DRAM interface.

Use an unsigned long constant for the multiplication so the calculation
is performed with 64-bit arithmetic on the supported Qualcomm platforms.
Apply the fix consistently to the v3, v3.1, v4, v5, and v7 SMEM parsers.

Fixes: 1d234eeafc56 ("soc: qcom: smem: Expose DDR data from SMEM")
Signed-off-by: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260827-glymur_dramc-v1-1-eba358d504b8@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smem_dramc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/qcom/smem_dramc.c b/drivers/soc/qcom/smem_dramc.c
index 63ebe7f6db590..9612230a03bef 100644
--- a/drivers/soc/qcom/smem_dramc.c
+++ b/drivers/soc/qcom/smem_dramc.c
@@ -219,7 +219,7 @@ static void smem_dram_parse_v3_data(struct smem_dram *dram, void *data)
 
 		if (freq_entry->freq_khz && freq_entry->enabled) {
 			u32 freq_khz = le32_to_cpu(freq_entry->freq_khz);
-			dram->frequencies[dram->num_frequencies++] = 1000 * freq_khz;
+			dram->frequencies[dram->num_frequencies++] = 1000UL * freq_khz;
 		}
 	}
 }
@@ -232,7 +232,7 @@ static void smem_dram_parse_v3_14freqs_data(struct smem_dram *dram, void *data)
 		struct ddr_freq_table *freq_entry = &details->ddr_freq_tbl.ddr_freq[i];
 
 		if (freq_entry->freq_khz && freq_entry->enabled)
-			dram->frequencies[dram->num_frequencies++] = 1000 * freq_entry->freq_khz;
+			dram->frequencies[dram->num_frequencies++] = 1000UL * freq_entry->freq_khz;
 	}
 }
 
@@ -248,7 +248,7 @@ static void smem_dram_parse_v4_data(struct smem_dram *dram, void *data)
 
 		if (freq_entry->freq_khz && freq_entry->enabled) {
 			u32 freq_khz = le32_to_cpu(freq_entry->freq_khz);
-			dram->frequencies[dram->num_frequencies++] = 1000 * freq_khz;
+			dram->frequencies[dram->num_frequencies++] = 1000UL * freq_khz;
 		}
 	}
 }
@@ -265,7 +265,7 @@ static void smem_dram_parse_v5_data(struct smem_dram *dram, void *data)
 
 		if (freq_entry->freq_khz && freq_entry->enabled) {
 			u32 freq_khz = le32_to_cpu(freq_entry->freq_khz);
-			dram->frequencies[dram->num_frequencies++] = 1000 * freq_khz;
+			dram->frequencies[dram->num_frequencies++] = 1000UL * freq_khz;
 		}
 	}
 }
@@ -282,7 +282,7 @@ static void smem_dram_parse_v7_data(struct smem_dram *dram, void *data)
 
 		if (freq_entry->freq_khz && freq_entry->enabled) {
 			u32 freq_khz = le32_to_cpu(freq_entry->freq_khz);
-			dram->frequencies[dram->num_frequencies++] = 1000 * freq_khz;
+			dram->frequencies[dram->num_frequencies++] = 1000UL * freq_khz;
 		}
 	}
 }
-- 
2.53.0



