Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058376;
	b=PnVMOl704WvUi+bvMNnq8bctgE9gweqc51uTrUmAAFpX7DTQuT7Z4m41eNXHJg8VuqtG
	 WHCvT8w5JJlXhbAgT+y2Smz9eNXPw6sN7I+VJvMPWH9p3A6pDcQZx8QQe3C65HOeFF5IA
	 2N626ecgIPG626A8qVjBOzeCo6Oqphgo6lkmUTpTc1E9lDpVRWwEEjIjANlp7d82qWkUN
	 W9KNDmN5wLA33cVWkqXbT95O1nTOMneQRG8tCDIBnyUyOCItSMB/25sQ+Xe2fDUZVSxNK
	 EOOHIngub/+XH71+riK+Z9Ofk72mOMoFXTt/cgHj9AHWWnDKlBAXGgyLRJEwuLLotlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XvL3sFK5k3m+uiC+9aFN27F0KcPIsj7CL4L/EJ4tWGE=;
	b=qCPc3BgqJAx/OiINXFFxUAipPTy4LqIFsLvujK5ocvq/V7koTS4YfOEdIgvVtBUxCWzD
	 izR9fvC2URjEf4j95OAdWbvbg2C+fETyEDk5TYLDKVx10Ju+OATltDLqcIWaabxfBbHJC
	 RU7hZfAqBUDzb1fyIRxpfQq80Hb6CPXqUMWDoDozAA4CIaXVTJPnQQfSJ0YCtl3Go+o7B
	 OwfrUGo0ZRkirvQJHpP5aRGg0rQllMnS0CP3/E2dLZrXBPpdUt7hYwZTGMrA5eticTGQd
	 5UDh/mee/1VuvqHJAhW/+1/t0Sr4gGGnVXXh9mqOuWdvv39Aon+zx/xgP6aOV5CRFlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YuNCvPhi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505AA606A31C;
	Thu, 19 Nov 2026 03:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YuNCvPhi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6A71F000C4;
	Thu, 19 Nov 2026 03:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058376;
	bh=XvL3sFK5k3m+uiC+9aFN27F0KcPIsj7CL4L/EJ4tWGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YuNCvPhi+jDmvH31TfpGieaygkucgiv2OzmmbQvCp616yFSyGlkROsssm/jNe0Oro
	 usVH8Bznvxv8Mk1ehQpJOPy2qBAWuazHeU7LOT7JEa5BTBh9E3ohvvnI0AQe32hPEh
	 voBvj/ZLt5vo3fizUeqzvTebQlBHjIUGCSBWowSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0463/1848] hwrng: core - reject unknown RNG names
Date: Wed, 18 Nov 2026 15:41:41 +0100
Message-ID: <20261118145933.785735794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 7e7be8815143751c20260f80cb4e7fe14dd24b74 ]

In rng_current_store(), err is 0 after successfully locking rng_mutex,
and if the requested RNG name cannot be found, the function reports
success even though the current RNG was not changed.

Set err = -ENODEV before searching the RNG list to reject unknown names.

Fixes: 142a27f0a731 ("hwrng: core - Reset user selected rng by writing "" to rng_current")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 6e2c1ba18012a..8f35019ea58e4 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -343,6 +343,7 @@ static ssize_t hwrng_attr_current_store(struct device *dev,
 	if (sysfs_streq(buf, "")) {
 		err = enable_best_rng();
 	} else {
+		err = -ENODEV;
 		list_for_each_entry(rng, &rng_list, list) {
 			if (sysfs_streq(rng->name, buf)) {
 				cur_rng_set_by_user = 1;
-- 
2.53.0



