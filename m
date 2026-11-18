Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047123;
	b=f1nPYqOfOYs+bwbIHiC0zCC2BRDuzkDrk057ucq6LQat0LeaMVAEDdVxxyqiwpCiJJvn
	 sOnqT0fKgJSD+E93Iizmh1chX1BzdLSDtSMcTCfTU492p+aumqEwo8m3kQsRO/9kJ8Fcw
	 nlgWh8cbH/afhzuWpPPzqApVmQA9zuONLNZvYWehGsrMq6u8AoieWZe985cJlfRGfAD0N
	 FIfmUSObRqonKs0fv6l+l33Lmj0Y7fmOvpchAloN2Ewg9NkH7RlYgRomAgd7ZNZaA3YCQ
	 q/O6i4ncw80JkTO4xAhdusmGAYCQ9S4ZEnhla99n6UecFSuOm9xTAfmP7Ta00JQev8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Gcs1Vs6JPompTmvN/U7m/TWpbZI9koqsL68IqwP3bw=;
	b=llNhd1+GSaM4FN+QhuIJckLo/tCcAxWW5R5qrVkWE5gmM+69FhWcu80cGMtikn+cHn7A
	 uIVzSoq2omJ7rXxPWuN7q3vrKapAZqUVONPgoJgiIHc9TzHVVoZc/fIon/NN6L06dqK5q
	 0S+uBK2S2KgeQJEKigp2CkXkZQXudcXi1/IbAcoS6k7ENTXLqllgFeW2MVIsdv8qJzziX
	 UpcNoksc/UlnziShVbcxNRjjqDC4UPkssUTiqxQSApaArFxs3IzINfgPzxxEy3Co+oL2w
	 P2Bx3CSKYZHNFd4N9ZTZ3n4kXZKKGmt4fY4y8z7jF7HLlhlYKgJDU6ZpuvqYtNcz13A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nPNYgD1f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA9B606A31C;
	Thu, 19 Nov 2026 00:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nPNYgD1f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A8A1F000C4;
	Thu, 19 Nov 2026 00:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047123;
	bh=3Gcs1Vs6JPompTmvN/U7m/TWpbZI9koqsL68IqwP3bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nPNYgD1fzCa4CVLnRRlmay/ULPY20QSzn8PssmYJ2UUvH8/cby2NYrVE24qfMAN7C
	 dtE6zl/sUyqSH4x4HUZT/HQnTlM9n268DAQ9+z+yV33KMVmGsP5e7XKZqb5Ah5yk96
	 EsHKBQ3EAn8IjLXH+XOTCKozXbyxvK6b7Dt6HeYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1526/2857] media: qcom: camss: Propagate vfe_reset error up the callstack
Date: Wed, 18 Nov 2026 15:42:40 +0100
Message-ID: <20261118150256.267248787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 5c07f30bed52ed85673b634f77467e404645785d ]

A previous patch I had removed the returns from vfe_disable() since we
didn't trap any meaningful errors. Konrad pointed out vfe_reset() could
return an error, which is true.

Trap the vfe_reset() error code and throw it up the callstack.

Suggested-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: e5d4b0e69a40 ("media: qcom: camss: vfe: Fix VFE reset while another line is streaming")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-vfe.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 3597788cc02fd..e333e4463433b 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -432,8 +432,11 @@ static int vfe_disable_output(struct vfe_line *line)
 int vfe_disable(struct vfe_line *line)
 {
 	struct vfe_device *vfe = to_vfe(line);
+	int ret;
 
-	vfe_disable_output(line);
+	ret = vfe_disable_output(line);
+	if (ret)
+		goto error;
 
 	vfe_put_output(line);
 
@@ -443,7 +446,8 @@ int vfe_disable(struct vfe_line *line)
 
 	mutex_unlock(&vfe->stream_lock);
 
-	return 0;
+error:
+	return ret;
 }
 
 /**
-- 
2.53.0



