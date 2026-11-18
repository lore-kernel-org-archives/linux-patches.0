Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023670;
	b=0r6ENyMskpSSP9qz/oCFaarGob/ZV/3j7jl2Kwrc3G/sbGx0jKVc9Oc8w2vpNXLJHM4+
	 vYs4OYm+Onm0dUR/CzacHyri17DkjivaP15o0LVQ/Pc8Qva7TI/v1RoyTs46GT6YZX3T8
	 KeE5whHghjFpuibTP/ibMV0+R3Zdl1qDaQfqKBkiPS6pG1FPzIqhgTmh2G6HnNfZF2Ppl
	 PfVYnMYY7wNikQY8tks38UpDcqJh33dxo6q8R//mVHzcjeyMSe943CJgP4P+K5LEYVDNe
	 TPYQoM/qrk/bVj1/Odshe23Ejfrw5jjDdu82Uwoocd+26nDgS7RmRcmiGqK7HSxJ/1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jcftTTtgZadt61snF94XNVTYN+bpS+T4/MeJblLBsa8=;
	b=Ngpyd3DYKh09oj8ZRpiMQtu2xVlQoeXjsXo4zPQZ2JUtHmP/sqb6YqQ1f+CEFFnJ1A4w
	 OW6pMyJUuDKTwIbn8Go3Vh37KKxxQcJQoFGBzF0/ivusj7iZ9i/nuMQyClUnmP/8pXoCY
	 YjMMZS8T3vrf6eEsC6BZUnvK+LWW2pCtGrfS1z9J4H2TPxLcAKXOC0kpGP9AzB1hY9Lua
	 xBekIEN9AfjH50O6yyQI7qw8/bfxIoqTIfKy+rzq494r+207M2M7f24km6HbJZVYnfUto
	 G0rlt74Q/N+Y3JxyxPtKE3IpcF8WHWdA32RBvJmXJFrtWXqCLXkuo0IZq525a4/w8CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UInvnnGZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763F4606A334;
	Wed, 18 Nov 2026 17:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UInvnnGZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C82071F000C4;
	Wed, 18 Nov 2026 17:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023670;
	bh=jcftTTtgZadt61snF94XNVTYN+bpS+T4/MeJblLBsa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UInvnnGZA2YrkpFqFi/A7U0k38bEppafDhjo2KsnnHJR+jLeO9RdiJ1MwHw5Rwl2q
	 pqrnah99gEuFPgXv7hSLQbQtWZ2Ke7JoGQH2blLxsY2VBvjMUexll+22x3PuqEU2hP
	 IxTrlxkyIoFbx1X2WmvXAd19Vb2mWIFxQ2/3B5E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0452/2151] media: i2c: ar0521: remove duplicate media entity cleanup
Date: Wed, 18 Nov 2026 15:36:27 +0100
Message-ID: <20261118150138.496420150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 069a0343581bfcaee44bc598e2b95be2e2789807 ]

The error path taken when ar0521_power_on() fails calls
media_entity_cleanup() at the disable label and then falls through to
the entity_cleanup label, where media_entity_cleanup() is called again.

There is no need to clean up the media entity twice. Remove the first
call and let all error paths converge on the common entity_cleanup
label.

This issue was found by manual code inspection.

Fixes: 852b50aeed15 ("media: On Semi AR0521 sensor driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ar0521.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/ar0521.c b/drivers/media/i2c/ar0521.c
index 939bf590d4b21..a9a33b4c8e63a 100644
--- a/drivers/media/i2c/ar0521.c
+++ b/drivers/media/i2c/ar0521.c
@@ -1139,7 +1139,6 @@ static int ar0521_probe(struct i2c_client *client)
 
 disable:
 	v4l2_async_unregister_subdev(&sensor->sd);
-	media_entity_cleanup(&sensor->sd.entity);
 free_ctrls:
 	v4l2_ctrl_handler_free(&sensor->ctrls.handler);
 entity_cleanup:
-- 
2.53.0



