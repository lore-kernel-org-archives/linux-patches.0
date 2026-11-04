Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829451;
	b=jC+pY3GSnZEwZ+0pMW6jwWFuPANYsEMtptORp5w/83n6Wx6NpZfpPOR2Ag5fYPm3a50x
	 Fzg+M+PJR3HqP9aob+/l7pIeYwerkEpegml2EblOb6lnrzJRUWhyuZpQoHT+F1y0bhUd8
	 DnUsqBh2FH8FXF6YX6slVAgxQc9dUu5Oh2sKY8rU8UQHGzjprltI3rVxKZCFogVB6pr/X
	 buJfciR0JAepzi1VuB+c0KFs9dzQhZ50SckUg3ly4FCfM6b/MORbppcvqHz40y9MYvwXF
	 EDgVG8R6XNtmNHAmN5KheEm329gkuXBBnsmdrGAX/D6bX7qAHpt/Mlc21ZHAcLj5geg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qt7nQp+6v6+LoplPhjMKlRkj6OTIzU6Ld2dBIbcA88U=;
	b=CfnXrJHUlRic+29H7+X2/Zoqn+CqjZ8YQ8BcPUnOWxMN0MTf0AszchOX52LckD200siL
	 rU9r7u6VOvKFIjyX69MZ+2g5gKiqBWzENzscCFmcPNmA1ciJTHf83i2K7jN82wtZjrNnq
	 ZR4CB+4Z+awqBGGolvEH9uau9YoRAFgVFoPK0pPmg8B/rdLYOncIsyoQcAR2f9TcN6+WP
	 QL5Vje+kohStUxYUkNWSeyhejREwViuDnKXTUCCe46Yl89AnVLyDGd9zvcsEHKLjKQOLq
	 R4tUztmJeNCV+omckt9mHgGaEacxtcdSt0RazTZANcotW37YQxiJbqeONJistcJcsRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qN8zCN6c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5D1606A862;
	Wed,  4 Nov 2026 21:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qN8zCN6c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212B11F000C1;
	Wed,  4 Nov 2026 21:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829451;
	bh=qt7nQp+6v6+LoplPhjMKlRkj6OTIzU6Ld2dBIbcA88U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qN8zCN6c+P33GnNyQjS0BPyrPGrzOLSGWK3xFPaHp2z/MJAZjfKdEQx+gWSdNduye
	 N93YYpt6bSDyQNltR0ZQ3Uuy63my6keOya1xGjFH0nMQSwESn8XGn0kqcbAMBtbMdS
	 0MbOXOY+077UbF3cf85K/3rgGN6pqLS30TZBIKhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0096/1005] soc: qcom: socinfo: Add SoC ID for SDM850
Date: Wed,  4 Nov 2026 15:57:09 -0500
Message-ID: <20261104211046.322019769@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 743af1d6a8b4bfa62dd01b5c2d81b1c62ea597f7 ]

Recognize the SDM850 SoC.

Signed-off-by: David Heidelberg <david@ixit.cz>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260627-sda850-v2-2-44bf46ade42e@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/socinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/qcom/socinfo.c b/drivers/soc/qcom/socinfo.c
index 963772f45489d..79a0defe73227 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -359,6 +359,7 @@ static const struct soc_id soc_id[] = {
 	{ qcom_board_id(IPQ8078) },
 	{ qcom_board_id(SDM636) },
 	{ qcom_board_id(SDA636) },
+	{ qcom_board_id(SDM850) },
 	{ qcom_board_id(SDM632) },
 	{ qcom_board_id(SDA632) },
 	{ qcom_board_id(SDA450) },
-- 
2.53.0



