Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031658;
	b=AaSXTZKVmksXKJVjnk4gpIFfmqZ5l/ESBTSdN9/II4+hQhuU9cGXYmcWKXlCjTnXEU65
	 2ERTfkBAguI3CUujvcKjG6U+Ey0Wq4teCMZeLmjnqJguGpUltUmfPlV0msRtyW/24tsku
	 7N4ie68lF/+Ex7lrABadElOE5yE6oplw7S7NfuX8ZlXjP6ka0PykEpluCFA12ud/ecjZ9
	 ycBh0QVJXQGIeLCGydPLVP6IpVemKDNOQYdPtbpTKww/4U71N9x0sghGrivRf4EkYWEvC
	 1sUk3MtCRdtU9+O5anAwNra2h+lMBEhI6qNg49f+u8HAZHYE+rC4mOW7JkLuXVPLoRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xAOgkYaacDgl2pwgKT4Y6/FZq56mtJV9IcUY4McSb3k=;
	b=3eaG3azZJVxihTnRwVysDapVjDMALMnPixh+eso1sXTso3FyeGYjqkIDcTb9E8VroXCl
	 lfAD0/qvErfER5nnZGSJL4hC+yz8dxXF2cvOdeHSXF11Nl8D0bB3OqXNfRQ666r2Y0WaK
	 ajjsm+qULdGoeuWGEnMSH7Lsgy9UO6Ssv7atDyNGncldoAEjjnvMcjbEpu3aUpiAh+xVA
	 BPRwTo5lkiTAHDlCizThJxtaYosLj5wRoGjPtjcZphuvLE6B6zFfB2uowaWMAhCGZ4MUp
	 POviQTDely33xEayUogyjwvXuUnjWhzS9a5Gnu8ABF9eaQFPZ2zlQmaKw96GC146e7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q1fkXdWX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63066606A325;
	Wed, 18 Nov 2026 19:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q1fkXdWX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A4F1F000C4;
	Wed, 18 Nov 2026 19:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031658;
	bh=xAOgkYaacDgl2pwgKT4Y6/FZq56mtJV9IcUY4McSb3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q1fkXdWXhPHZ7N4NUTVtmmxT76SmLRpdnI/D3iW2Cv+ykLtSsjMi3wwhqrvJnoIwF
	 jKmw9WqJtXXAypbcqnZ5U+NE92scglM9Nuu8CE5xIIJmHb6/nqGghebK6yS5W0ZO3N
	 5f0meHD8fHaELMRz7Y9TxGz5u15dKDBy7wyYUVFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1134/1756] bus: arm-cci: Drop cci-control-port node reference in __cci_ace_get_port()
Date: Wed, 18 Nov 2026 15:54:21 +0100
Message-ID: <20261118150055.212924816@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit 810ccc792193909ba9bbb4246e0eb0de14dad724 ]

__cci_ace_get_port() looks up the device's "cci-control-port" node with
of_parse_phandle(), which returns the node with its reference count
raised, and only compares the pointer against the probed ports.  Neither
the match nor the no-match return releases it.

Drop the reference on both paths once the comparison is done.

Fixes: ed69bdd8fd9b ("drivers: bus: add ARM CCI support")
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Link: https://lore.kernel.org/r/20260923164122.596910-1-oss.patchbox@gmail.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/arm-cci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/arm-cci.c b/drivers/bus/arm-cci.c
index ab9b49451f8f2..25a741e48573f 100644
--- a/drivers/bus/arm-cci.c
+++ b/drivers/bus/arm-cci.c
@@ -167,9 +167,12 @@ static int __cci_ace_get_port(struct device_node *dn, int type)
 	cci_portn = of_parse_phandle(dn, "cci-control-port", 0);
 	for (i = 0; i < nb_cci_ports; i++) {
 		ace_match = ports[i].type == type;
-		if (ace_match && cci_portn == ports[i].dn)
+		if (ace_match && cci_portn == ports[i].dn) {
+			of_node_put(cci_portn);
 			return i;
+		}
 	}
+	of_node_put(cci_portn);
 	return -ENODEV;
 }
 
-- 
2.53.0



