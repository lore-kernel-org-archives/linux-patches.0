Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216515;
	b=swH53T2luRJfq5bx8OWwXvPF+5UcqTsPJtWMmsmPjAzOVkhQrWPOIqIz/bVfr3TIcccv
	 MtDG3hhxrV0ITFmMU2/yFuQp8ujby7pvKDgTv4RbexoR95hiQ3DFdnB9RYYOhAmA/h5pb
	 aMgZE4szzGSn7AAVZJqxPah2+gCmOR7M7bilyv6rlTA8Rk1wBGmUrXzDKClRZTVb08dGj
	 z7KE+xU9I+4g+6CJ80accx3JTj6u02mlW9R0AdWJQT4zxiFE8Vw3tyxYuA6lN7v4HxClo
	 Vs2verOl8WWxDInf88JeSzMRXoql6+OuEhatAJXPFXn7PCTaUkUxnSIsc/MJys5iWqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mYJ1m9DyW9trwF3XiOxTT+w+gBkYq+oQhBVgYyq+hkE=;
	b=VVt2DTmC/Jn1miBpa8DjPa0EF5/Wm89Gpwh2dq34WejMYtyU5nuzHW8RNC9oMF4xMAjW
	 qSR6V1wF3e53OJeNUFfMORiU+q37BNw8Bfo7RriXklt/tFYmC5xs0SHJZYebe+PG0Y5yD
	 JxNazFSpPzwLwguRN3AofGrchNsMtjOS+oQl9G2vw4Qa8A8WezHZaOMqAgjKTghY/e2iV
	 cc/KLVQvAGruSkXHxr2I3hca+zkGbSiFdQinC4MSjMJbQILddt4BEK9+9b42RMa7JbjPM
	 tBQT+InHpktwBSR9i1LvAljf+Gftm8NhlAw2bdz4y3sP97riB3aIKXhc4mSG6rcJM8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KMzO6Wue;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C87606A31C;
	Wed, 28 Oct 2026 19:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KMzO6Wue
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D81F1F01825;
	Wed, 28 Oct 2026 19:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216514;
	bh=mYJ1m9DyW9trwF3XiOxTT+w+gBkYq+oQhBVgYyq+hkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KMzO6Wuej3BtpS1K2OuCFiHOxWE47LDKyLW7M4YDwsxf763CGXP4j15m9fvCHgG0U
	 FAHPr/pGrB9Yhc1Ba5XUwrgoN8s1xAKlWZTYxApVUoF56rlOydqvHaiTW9aGXLbn+H
	 bTsg4iFuCdkFcw+FDJ2h3kHliEqfX/LccmGh2+II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1582/1887] HID: logitech-hidpp: Fix FF device cleanup on init failure
Date: Wed, 28 Oct 2026 18:01:18 +0100
Message-ID: <20261028170535.466622052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit dd5be4d9ce2dfc4d4a4527ef7d31d21a78e3cdac ]

hidpp_ff_init() creates the input force-feedback device with
input_ff_create(), then allocates the HID++ FF private data,
effect ID array, and workqueue.

If any of those allocations fail after input_ff_create() succeeds,
the function returns an error without destroying the FF device.
Add an unwind path that frees the private allocations made by
hidpp_ff_init() and calls input_ff_destroy() for failures after
input_ff_create() succeeds.

Fixes: ff21a635dd1a ("HID: logitech-hidpp: Force feedback support for the Logitech G920")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index ebaca3588342f..741be3c1fe5b4 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -2634,18 +2634,19 @@ static int hidpp_ff_init(struct hidpp_device *hidpp,
 	 * ownership to FF core
 	 */
 	data = kmemdup(data, sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	if (!data) {
+		error = -ENOMEM;
+		goto err_destroy_ff;
+	}
 	data->effect_ids = kcalloc(num_slots, sizeof(int), GFP_KERNEL);
 	if (!data->effect_ids) {
-		kfree(data);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_free_data;
 	}
 	data->wq = create_singlethread_workqueue("hidpp-ff-sendqueue");
 	if (!data->wq) {
-		kfree(data->effect_ids);
-		kfree(data);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto err_free_effect_ids;
 	}
 
 	data->hidpp = hidpp;
@@ -2675,6 +2676,14 @@ static int hidpp_ff_init(struct hidpp_device *hidpp,
 		 version);
 
 	return 0;
+
+err_free_effect_ids:
+	kfree(data->effect_ids);
+err_free_data:
+	kfree(data);
+err_destroy_ff:
+	input_ff_destroy(dev);
+	return error;
 }
 
 /* ************************************************************************** */
-- 
2.53.0



