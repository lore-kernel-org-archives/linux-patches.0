Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023532;
	b=dmK0iEfSjG6RXCP+Mlw+nffdfz4bEPD9gl5e2LquUCLlLhUMFGa7YXCHDoCUIBvtxG7g
	 y/T2juUKlzq15/LoqmjxW3W92OF/C9RJSqE+oHNf/V06UCFTafypna5VD3FAxy61BEA9l
	 edrzegyGW/nsC/xIcWXa1ZkZzVovq8Ay/7kHM32ekLYWGsOoSTW1cIRW4nnODX8PkFM5C
	 9t+uHIU9ECavP2+CLPQR5atTVCsdQO9IZFxU2KsO4DylbQSOgC+27Sbq8cgGBHyfQ+zBG
	 Jk4Q2jVFjS65HMFcc8Qf0VxLpn9jyPqRj+peeQWrm0ceN5dshhdgyXp8E7MZNx+Zs3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fdrhE/9/11LgP78wbdKNcSfDdCry515sCXA3+5xw+hc=;
	b=lYmKBME51hpqtNM3m0BNgJYMUE6cD/iNWcHpuHUnYbL9itVXNnpfNREwb/4BVm/3lcYd
	 3j0eTGsE/quAZ4BuOoXmRtaRFJI2EJy4J89PtzUyBikuegR+IgwAMKYPFNh/JQQ3HLzy8
	 1znOMU8vhfcsGv/L7GRwBBVio5ams7lDYL/fws3aa9yYrUgNQTZQ9LhJq3+WSWUDpfFYY
	 o/DpPdrxD5fIOi4xQw9Z4yAqhIsw4Qd0oyo6JXCjcKLWHAUWMriEV0p4L4/6SP8w1IHKg
	 f2OkfZHS6kYNksyxgVCbRSftB3sHkfTPT6VUEUBaddAPfYu5kO4rxiX2BSkjRhjuc2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zMdHszPE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB19606A31C;
	Wed, 18 Nov 2026 17:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zMdHszPE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC251F000C4;
	Wed, 18 Nov 2026 17:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023532;
	bh=fdrhE/9/11LgP78wbdKNcSfDdCry515sCXA3+5xw+hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zMdHszPEJwxjsoEVgzyARAsnLQI+hDmcUVhRUOqwyIspWuFA0m8nrMNaT68p4iCjf
	 ai129pOmNt9R9zQvn/iyemkIteqExHEJVnfNlO9q1fc9WcU85upJaV1MY5gC7iu0Lg
	 NY9tOf3+oJSlcIkOC3tncPUrcZU1fRhpgOFUaXG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0403/2151] PM: runtime: Only queue an idle check for RPM-linked suppliers
Date: Wed, 18 Nov 2026 15:35:38 +0100
Message-ID: <20261118150136.741975210@linuxfoundation.org>
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

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit be5755f023e7e02ec90bbd1d4ca63a0abe594733 ]

When a device RPM-suspends, it queues up an idle check for all of its
suppliers, in case that device was the last consumer, and those
suppliers are now able to suspend. Today, we do this for all suppliers,
and not only for those suppliers that are marked for use by runtime PM.
This isn't directly harmful, but it is a bit wasteful, and also may
induce unexpected suspend attempts (e.g., if a device was purposely last
touched with pm_runtime_put_noidle()).

To avoid excess idle checks, only call pm_request_idle() on linked
suppliers that opted into runtime PM.

Noticed by inspection of trace logs.

This is not expected to have a functional impact on systems that are
using device links properly, and should only be considered an
optimization.

Fixes: 5244f5e2d801 ("PM: runtime: Defer suspending suppliers")
Signed-off-by: Brian Norris <briannorris@chromium.org>
Link: https://patch.msgid.link/20260901013341.1417232-1-briannorris@chromium.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/runtime.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 6980a8dfced2c..e487f8892d3ea 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -361,7 +361,8 @@ static void rpm_suspend_suppliers(struct device *dev)
 
 	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
 				device_links_read_lock_held())
-		pm_request_idle(link->supplier);
+		if (device_link_test(link, DL_FLAG_PM_RUNTIME))
+			pm_request_idle(link->supplier);
 
 	device_links_read_unlock(idx);
 }
-- 
2.53.0



