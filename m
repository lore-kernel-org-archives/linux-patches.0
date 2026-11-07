Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062145;
	b=gY1NyVlLSlbALZa2+Jc8TbKM8AxZPrYUgmxS6nuzYU7HCNeLYe98hg8ex2iMWPef2I8B
	 mybVfVtdfsXx5zXm4Md5UMzbG1WRKlCFqtzRH9j9Kh+UoYeX06VWF7TaeC1bXrvvde8v4
	 kQF2MklK7kAop4ilQfMvUpKYvV8z8hxFfvsyR2sSRd2hpSjE/K2jZdF+PetG1z0Hm0DgO
	 Q3zPiigC81Yfm1muacjz3JEnAO86v0Jt7BJg44g0wZXCtdxBSY8ADEfzSqhfHInyfK2D+
	 RzRv2ZybB9yQ9Z/zGQtWPSiNj+QogUbcwQTIVch5qbuw1jwAKD12RCi2haMrqdKo/hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FchC/BE/fLx15EyPeQ67jyvbefJtLfTjX9akaJ+d96E=;
	b=UbPyzWUxX/3fx5mknNDaPk2EK4tNs5fSdspeEIiD2b1a8ta1kdr5NQlO6Edly/hRNPUv
	 /DwZPsQ/8Zeyv/yTuAmOzVBqbYQ+jsAK3GjKKm7NYKaJTajhXNPCayOtwb8b2JYQPfbHE
	 LGYOMQhoKWbCqP7nYoI0v6qLhSnCLRBcY3fzAjJwULn9hU6bWtTQlwBHg/qADmSR2P4vq
	 usRCVNWw9l5ui6z3P+flgwBROTPXkZT2pryDuqTIShQlMalnrE/llfBMftC9/f/W7Z14E
	 vlSwOoHdCT2idzj2aYcYB8ATDRxUzsvpL1cqI4Z+es+Pr6giZpZxJOU8H5Fc0fkwM8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l0H4eg5X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6D2606A653;
	Sat,  7 Nov 2026 14:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l0H4eg5X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBC51F008A3;
	Sat,  7 Nov 2026 14:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062144;
	bh=FchC/BE/fLx15EyPeQ67jyvbefJtLfTjX9akaJ+d96E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0H4eg5XHeRqweIZ1EysShHkKcAUjx30YQHf/3Z1zbXir8iicC7UCkTu+5c3xM09I
	 BfO+QjgY9/MvDAUzdHAJCvEULFtDHvZubJxDzREsZW7uWvaazSh4k+q3e3wAajd4sr
	 qh3ZjUKK0dEFlH5zKM1OZ/2Kn7RVOFm28lZw7YQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Greg Joyce <gjoyce@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1109/1536] pseries/plpks: clear SED key data after use
Date: Sat,  7 Nov 2026 08:52:05 -0500
Message-ID: <20261107135028.852526935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Srish Srinivasan <ssrish@linux.ibm.com>

[ Upstream commit 217ba01e5b9096091acc2c1a3776cb3eb88c00ff ]

Explicitly clear the temporary buffer containing SED key data after read
and write operations.

Fixes: ec8cf230cecc ("powerpc/pseries: PLPKS SED Opal keystore support")
Cc: stable@vger.kernel.org # 6.7
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Reviewed-by: Greg Joyce <gjoyce@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260923182816.151451-8-ssrish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks_sed_ops.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/plpks_sed_ops.c b/arch/powerpc/platforms/pseries/plpks_sed_ops.c
index 7c873c9589eff..ac3ec2ca7fbee 100644
--- a/arch/powerpc/platforms/pseries/plpks_sed_ops.c
+++ b/arch/powerpc/platforms/pseries/plpks_sed_ops.c
@@ -84,14 +84,16 @@ int sed_read_key(char *keyname, char *key, u_int *keylen)
 
 	ret = plpks_read_os_var(&var);
 	if (ret != 0)
-		return ret;
+		goto out;
 
 	len = min_t(u16, be32_to_cpu(data.key_len), var.datalen);
 	memcpy(key, data.key, len);
 	key[len] = '\0';
 	*keylen = len;
 
-	return 0;
+out:
+	memzero_explicit(&data, sizeof(data));
+	return ret;
 }
 
 /*
@@ -102,6 +104,7 @@ int sed_write_key(char *keyname, char *key, u_int keylen)
 	struct plpks_var var;
 	struct plpks_sed_object_data data;
 	struct plpks_var_name vname;
+	int ret;
 
 	plpks_init_var(&var, keyname);
 
@@ -127,5 +130,8 @@ int sed_write_key(char *keyname, char *key, u_int keylen)
 	vname.name = var.name;
 	plpks_remove_var(var.component, var.os, vname);
 
-	return plpks_write_var(var);
+	ret = plpks_write_var(var);
+	memzero_explicit(&data, sizeof(data));
+
+	return ret;
 }
-- 
2.53.0



