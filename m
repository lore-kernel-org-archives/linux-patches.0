Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619931;
	b=oNE5xM6Ua7i1hIJpN/5+6kvHlyFIDlyU2LzFIqXnkhhOVIvcHCr9fmR2oAPsyPvHML/i
	 nLZegUp1ZGfe+r1ZP/eQCEeQFLsh8q4FgRcbjPw9PMYC4IdMnxm9/ZVRTxjp50NS5LGxu
	 ueKv52Ib4iduawq6qebw+2Y2f4EJFCTro+/TNLigWS99BSAzF9HtfuJWsmfiKMobYl6M1
	 7JQvDk9BCk9LErypQTd5wXI1Ztdyid85DfCCO/zF8phXI4Xue+qqDQJok79vcg30XUMHh
	 SnPHFIygfZFG+np42jtmE5ImdgyxvX73mTglXetNjr/ZVC2RvZfVVYbphgIbytrTFsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y70P143RoREUfOEImEEuvjDFrxqkyA4m+4pN3EZFr+w=;
	b=zd228MKWlIJQqzxqSpfeyL1UNFfaFtXoL269qcEkeN0Mz0gQIqN1iBxnlLSNC2I0jq93
	 uD/xgfnxBijBui/YM8O82MXqr0N17FtV6Ci0qG21W67GRHtnm+yozFQTSYdNXBsyxXkPX
	 isQxp3w6gIdUH0R/ZFUAC9Kt2EgqJNsLHxBAK1DyYaX9HFFh0+KC8Xpp271MtN7pOqAfO
	 1UXNQQ4xWjBSbGiatBjJ/gzk+IlEkCsqbr4W9pwXME3KyxMycu3TO1KCfo3GXzvQEhU5W
	 O4OBhHjFeHVPWXf3Y4gmFY3mLCLwdON1sekPFIAIIdEfYewFLNZmyADb5c4fLqMeaWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AftbFDDe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5D6606A31E;
	Wed, 25 Nov 2026 15:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AftbFDDe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07EE1F000CA;
	Wed, 25 Nov 2026 15:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619931;
	bh=Y70P143RoREUfOEImEEuvjDFrxqkyA4m+4pN3EZFr+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AftbFDDeEH4qVJtGgcivNrHNcXRxHVjrRWrfr8iyemx75kzKnnpovnHVfSf2gtGaG
	 IFEdTnwjZfaoydARrjvMYluwhMs+lFSNdgPQ7+IVS1Sldth9tPOSQArnYzfdgL4yrN
	 5Gjc4KJtAFQ1OMngfEEWfWKzufzU6spXQiVuXIyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Aleksandrov <lightofmysoul@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.3 0754/1005] hwmon: (max31760) Report 0 RPM before the first fan speed measurement
Date: Wed, 25 Nov 2026 15:34:52 +0100
Message-ID: <20261125143839.408108128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Stanislav Aleksandrov <lightofmysoul@gmail.com>

commit 33d58cbf2ab26bda81bc3052158d8b9867d5b9a6 upstream.

The tachometer count registers initialize to 0 until the first
measurement cycle completes after power-on. To prevent division by
zero, tach_to_rpm() clamped tach == 0 to 1, causing it to compute
and report 3,000,000 RPM (60 * 100000 / 1 / 2).

Return 0 RPM when tach == 0 instead.

Fixes: 38b04ad02d0d ("drivers: hwmon: Add max31760 fan speed controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Link: https://patch.msgid.link/20261108-max31760-fixes-v1-3-a61450463059@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/max31760.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/max31760.c
+++ b/drivers/hwmon/max31760.c
@@ -68,8 +68,9 @@ static const int max31760_pwm_freq[] = {
 
 static int tach_to_rpm(u16 tach)
 {
+	/* The count is 0 until the first measurement */
 	if (tach == 0)
-		tach = 1;
+		return 0;
 
 	return 60 * 100000 / tach / 2;
 }


