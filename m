Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033664;
	b=eCrmSpdPOpKDXCN0ETd1w+UK1dQvkB2r3yRpFsZtQzNBqY5+cDEeiNpAdZq+p9uEPOKD
	 0FQJbVZIaAyRJXFfe8lF7myGpcKMDIEHWAj6mQ7lVt/vmiw4aXk0YhVRLNAkfl6uP2mIs
	 IkQpPxQwf1trwmwsSJWKAWpf6SyyFjBgKkblAYQBaKe9z/i4x/3f68VeH/8HqoKBMPLk2
	 3d1jI7WjRY3crD/rcQj3JSEqIAHwOJxdPLmFcVyJ5a4PAB+biX7NM5aArsz3/Kf7zICkZ
	 HPVEb67G95CO7kkS1svqdxxismUXAUPLAAdcRjNwOfPmYqEwoxKCdoMC0Q+9yzRynjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KKVyQAY18p6qH4aTxK0xF3E+lH6GQLI8Ap+fLZAzR78=;
	b=0yWGoAM+bu1ovdCFPzNw8tRHrpuK565l2Kfb1Gad7GLdHc0h0Ccf8XU96E87vtSdTsXR
	 CZohOpgAFrRN3O0SQtP+v/PIieyo+qLP0j1HgWhA3YkjWXgEhXEuNizsFKw/fzN1z7SxP
	 n6bCgFs69vVPpBFRZaQ34ExR5PnwfWK7fIIQTGwlLrDKkpBu3prMpUqWWt6kU9XJaXj/T
	 cPlMigF263R+wQflgpisTRsejqXyaOtOOYKR2ZIee1LNtWFGl9Ys3c1+AWTfQhmvXdrie
	 dE9lw6YRQ+jI1yzFLeukUzfJDjMMBy+Aa+qJN9hsP1tYXzw+isKs1+QNU6wOsaNX6Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B4ihOzll;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11146606A31C;
	Wed, 18 Nov 2026 20:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B4ihOzll
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602531F000C4;
	Wed, 18 Nov 2026 20:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033663;
	bh=KKVyQAY18p6qH4aTxK0xF3E+lH6GQLI8Ap+fLZAzR78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B4ihOzllpN4LpvEsYcuuMqsv8f3tKuvnUZKn9aCS6dGr+qIpvcbYFrkZJLH0Dx+1Q
	 FZq+An5lhnJzZ5kAOSd73YS1Et3LOTjXYouKKKuHXTgQUog+VjSSNo+zGRlVWi4yzv
	 Kk1MT9jPNteKOP8OOFwsiS5f7VmOLDL0Ircn9kCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0095/3318] pinctrl: sx150x: add missing MODULE_DEVICE_TABLE()
Date: Wed, 18 Nov 2026 15:11:57 +0100
Message-ID: <20261118150317.025733741@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5fe4b12c087db3e565f53b87f1dafdf2f0d1ee0f ]

The driver has a match table for the i2c bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-sx150x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-sx150x.c b/drivers/pinctrl/pinctrl-sx150x.c
index fef1ee7b7945b..64195adf84c04 100644
--- a/drivers/pinctrl/pinctrl-sx150x.c
+++ b/drivers/pinctrl/pinctrl-sx150x.c
@@ -849,6 +849,7 @@ static const struct i2c_device_id sx150x_id[] = {
 	{"sx1509q", (kernel_ulong_t) &sx1509q_device_data },
 	{}
 };
+MODULE_DEVICE_TABLE(i2c, sx150x_id);
 
 static const struct of_device_id sx150x_of_match[] = {
 	{ .compatible = "semtech,sx1501q", .data = &sx1501q_device_data },
-- 
2.53.0



