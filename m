Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047442;
	b=W1RD/4Gc+uGkCse529Mxs9XlEVxxdVimxiS+I+tavxH+oO091it13+iJknhFFTHx0IjR
	 BHBNpf7DsRLRnwpT8K758UmCCbU+xp+H5N7xVW9y2LytomWDS1kInaoWiEtYzgrHFCyOR
	 yX1RGpc2S7zOsn+5tOnDCYmdolptWhhppp9A7CB4RXdFUrQFpfBBr7jtY/uHMH7IlsXjH
	 PIAogGFRUhLVFjuu08jiEdDgJi2G8J/L67ytn7qsgXnBAxFLQisZG+59ryLi7Gs2+Xw/3
	 KTzJIVwciaLXG7L3OkEjk3wqMCyKAtEfTkE652h20h6On79H0PbE9GRJs6/VwoC6M7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kBFGiPi7SomZgd917SfBe6HXSX95kBOz4ycb3MaQOi4=;
	b=fMyXaeBsiuUTn5UIJCPKCRQev86IkSUvHEbL3Z474uLof4l3GtOtDE5JfBLaoCs9Jgu4
	 bwBWAboddSJO8HTBGbCkSKujy0/8Lto0FNebVfX+sRiQuY0BIh6Y6rx80/MWH6oW9ugox
	 qw7nJ2BW95CLulZFIXBj6enD+XkySl7tE7p1+zS6IxjAP/e7WTdSdflu+GULhL/7I0xDJ
	 XIZa2DevVJ1vXXh6IQ7Eyu3BfdMEedm0xB0w+14ju0VgYx9LgNNyb8nXBOpvaKrO6D4Kg
	 5fgb7jL6YtQlZqZzxY8BBECHorxYeBh1yEPiA9GMJ5DKD8aFFB3TVF26TXCpMkdeayw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1dxMJJFI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583B5606A332;
	Thu, 19 Nov 2026 00:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1dxMJJFI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F481F000C5;
	Thu, 19 Nov 2026 00:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047442;
	bh=kBFGiPi7SomZgd917SfBe6HXSX95kBOz4ycb3MaQOi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1dxMJJFIiRusFOGVesj5GzTaJI9LZVkU2WluZe3VaYUP05WS7p9DO6Mbqz3gNrb0j
	 s+7xqQt9eTNujkGjCtBaKqRdHfYOSEpRL7Sz9kfHr/wvlYqO9HY9JOTNc7Pi2O8CZV
	 XMnNVbJzhSToiQIsyvIv1saNhXIlznwo+pHPGE+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Russell Currey <ruscur@russell.cc>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1599/2857] powerpc/pseries: Make caller pass buffer to plpks_read_var()
Date: Wed, 18 Nov 2026 15:43:53 +0100
Message-ID: <20261118150258.946904103@linuxfoundation.org>
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

From: Andrew Donnellan <ajd@linux.ibm.com>

[ Upstream commit 0cf2cc1fe4e2e7a37da077cdd3fba5cfd9a6a36c ]

Currently, plpks_read_var() allocates a buffer to pass to the
H_PKS_READ_OBJECT hcall, then allocates another buffer into which the data
is copied, and returns that buffer to the caller.

This is a bit over the top - while we probably still want to allocate a
separate buffer to pass to the hypervisor in the hcall, we can let the
caller allocate the final buffer and specify the size.

Don't allocate var->data in plpks_read_var(), instead expect the caller to
allocate it. If the caller needs to discover the size, it can set
var->data to NULL and var->datalen will be populated. Update header file
to document this.

Suggested-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Russell Currey <ruscur@russell.cc>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230210080401.345462-20-ajd@linux.ibm.com
Stable-dep-of: d52a1659cb17 ("pseries/plpks: fix error handling in plpks_read_var()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/plpks.h       | 12 ++++++++++++
 arch/powerpc/platforms/pseries/plpks.c | 11 ++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/plpks.h b/arch/powerpc/include/asm/plpks.h
index 9e2219b0202db..4652ad319858e 100644
--- a/arch/powerpc/include/asm/plpks.h
+++ b/arch/powerpc/include/asm/plpks.h
@@ -82,16 +82,28 @@ int plpks_remove_var(char *component, u8 varos,
 
 /**
  * Returns the data for the specified os variable.
+ *
+ * Caller must allocate a buffer in var->data with length in var->datalen.
+ * If no buffer is provided, var->datalen will be populated with the object's
+ * size.
  */
 int plpks_read_os_var(struct plpks_var *var);
 
 /**
  * Returns the data for the specified firmware variable.
+ *
+ * Caller must allocate a buffer in var->data with length in var->datalen.
+ * If no buffer is provided, var->datalen will be populated with the object's
+ * size.
  */
 int plpks_read_fw_var(struct plpks_var *var);
 
 /**
  * Returns the data for the specified bootloader variable.
+ *
+ * Caller must allocate a buffer in var->data with length in var->datalen.
+ * If no buffer is provided, var->datalen will be populated with the object's
+ * size.
  */
 int plpks_read_bootloader_var(struct plpks_var *var);
 
diff --git a/arch/powerpc/platforms/pseries/plpks.c b/arch/powerpc/platforms/pseries/plpks.c
index 00137d6a303cd..b66a980478fec 100644
--- a/arch/powerpc/platforms/pseries/plpks.c
+++ b/arch/powerpc/platforms/pseries/plpks.c
@@ -528,17 +528,14 @@ static int plpks_read_var(u8 consumer, struct plpks_var *var)
 		goto out_free_output;
 	}
 
-	if (var->datalen == 0 || var->datalen > retbuf[0])
+	if (!var->data || var->datalen > retbuf[0])
 		var->datalen = retbuf[0];
 
-	var->data = kzalloc(var->datalen, GFP_KERNEL);
-	if (!var->data) {
-		rc = -ENOMEM;
-		goto out_free_output;
-	}
 	var->policy = retbuf[1];
 
-	memcpy(var->data, output, var->datalen);
+	if (var->data)
+		memcpy(var->data, output, var->datalen);
+
 	rc = 0;
 
 out_free_output:
-- 
2.53.0



