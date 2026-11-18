Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018893;
	b=w/aU/lrrENvRIKhzk8XW8JkEnBuvrbCviGaQKvGkoJVV8i/p6jgQRPyuMW8U0707Qkgp
	 +11KmSG4F04VvOaWZvh6dl9NlOwTcgM1HQnQx/WkdEvKk9Ue8cUMHy6rdhwfEYJ4+tuF3
	 xFzQNeKw4lZ4mlV06fqt7fXUD8PL3ekUoscrfUAMJ2jdsIFuXzy0V6VFTCt1XhCasTseQ
	 N5VI4EWCnZse3AIBXWiLpVMgFWJRQ8gvvkY+Pi2mPLZ0nHSNAGreZ7eadXHGAIMEet/iS
	 qA7Vqe2vE3c9HV6CmcMJc0ExU3chgqMCgGURORaLqb9KxUFc1mvM4/P1dZTMjk5Iqkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ugWddpRFYVyaJdx/Aq8PVESz/0FdEQ7cnmDMcRRDdGk=;
	b=R8Q2C8wnixAvgI3XfsXG/KoPDw5whBJiqCvz972p58H19kLxfoRKplDDnENTmTYOIxVe
	 xMb9gbqOq58FVbHJMn30Rj6df+HfMkXMuk08t3UQOAg5XTghxX5uQNuG2Da178JtkWyTg
	 yW+/YYaDBzmjNN/7LYyj8TeyxZeNcrlcpOsk41NP9ZpMKgBB3jTA0NNqNuYhNFH4Ppuye
	 SjSXLhTojDZ9jpHsoERzmx9ncBoq5QUawOB0ggi40datGSeX9U+5JufekmnveJ0YsGGuv
	 KJKqkEfhT4VERunsYgp0axI9A9kkjkv5oj5RQ/NdTcsL4PtWiVEht62uRKLb5ykllLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=prGNARd5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B29E606A320;
	Wed, 18 Nov 2026 16:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=prGNARd5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBEA1F000C4;
	Wed, 18 Nov 2026 16:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018893;
	bh=ugWddpRFYVyaJdx/Aq8PVESz/0FdEQ7cnmDMcRRDdGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=prGNARd5vuTQasn6t0J4rBMMSfAgine0dpN8Uz57SbEBfuL62Stu5D4C7iv5a7UDI
	 lPoU0XUOhdJgJqvt75x8K1BX6weJ5S9pCRSjM6RqvlrstfV5DiT8T3QC3/CnmXlEjc
	 QvqZ6kphMnPw40ofb7JX/E4iaoC3uz5NKRf8ivKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1403/2651] wifi: mm81x: validate n_channels in disabled channels response
Date: Wed, 18 Nov 2026 15:44:03 +0100
Message-ID: <20261118150338.522427525@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit ad130fe516914076f3fb11940b1bf9181de04425 ]

mm81x_mac_check_fw_disabled_chans() iterates over n_channels entries of
the firmware response without validating the response length against
the array size. A firmware response with n_channels larger than
ARRAY_SIZE(mors_s1ghz_channels) reads past the end of the response
buffer. To fix, make sure we validate the length prior to use.

Assisted-by: LLM
Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Link: https://patch.msgid.link/AS8P251MB00015A3FFF9F9A9628CB0BB0C8BE2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
[slightly reword commit message]
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/morsemicro/mm81x/mac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/morsemicro/mm81x/mac.c b/drivers/net/wireless/morsemicro/mm81x/mac.c
index e3740ba0f91e1..5cd55db33ca2b 100644
--- a/drivers/net/wireless/morsemicro/mm81x/mac.c
+++ b/drivers/net/wireless/morsemicro/mm81x/mac.c
@@ -279,6 +279,11 @@ static void mm81x_mac_check_fw_disabled_chans(struct ieee80211_hw *hw)
 	if (ret)
 		goto out;
 
+	if (le32_to_cpu(resp->n_channels) > ARRAY_SIZE(mors_s1ghz_channels)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(mors_s1ghz_channels); i++) {
 		struct ieee80211_channel *ch = &mors_s1ghz_channels[i];
 
-- 
2.53.0



