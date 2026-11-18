Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016123;
	b=SwQ1wvfXG4DyMbqCQKPFgtB/BcQlBgBx0SPxmpIMl48RC5yN+nrneyXGDm+Yqidr9upG
	 8xyzhrrLp4qm6Y28IXdFXtk5Q0nPF5MvVxeik1F0rvmBkaff1P1q0rWDSG4D9zNP4L886
	 Hhou4QTCsqBz3BbMSpMPN0mCLMH6ncq0ZOUtlccowwVpaGxe3pMJ36586EYyiyBoOCqwI
	 464pEtM0mJxUTsAOvNHl7dE3tbz1GkRPppPnhD2JTjN9Y4H8omYzTHGEK/MYGBDhNxSgC
	 pJypJGnUNE2oTRY5aemKrUAnVIMFHC5sIiEsDiVWaZUkoly34J9zErh5buApzWT9jIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016123;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c+zd6IM1o7xGq7gXaneNQ3Y3qvbslkJqq0pE9xHACzg=;
	b=SjK58wX9FGXcK0QDRM3RhZfGsSTDQaRZyjP2PU0wHlpdx91T77t9WtpmGBfmcNBJ7uFw
	 qqO9nV/Z62pfa9Zbu8IfAt5qGXmYFG8IX5oWxmYsnz+kuNge2wo976TlZD8vQqzPeiEF3
	 37EBbceXs4B6z66dNKWX1XtzAEfpUg32uj9uON3dvki++fFhrXlfWUhTE8WOw8STS/tGG
	 v6EMDM/CECtZ8wWgzgg1puZIeqZhoVk6Z25xr3g9bNFn623ASZn5ik98fyf1ppmZ8HtwU
	 WRqopHE/LowWPaR6GdtPQkQMM5OF9yiTIddQ5TkK9++cSawa3f37o1mZqJYWabR+Y5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IWgJWNfc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8600B60A2605;
	Wed, 18 Nov 2026 15:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IWgJWNfc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B741F000C4;
	Wed, 18 Nov 2026 15:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016123;
	bh=c+zd6IM1o7xGq7gXaneNQ3Y3qvbslkJqq0pE9xHACzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IWgJWNfcw1lf/LqdJlA8s0LC9zqZzryJhSb6kO/31cgem4K+fpmqEP0x9/0U1QHYS
	 BBUvSchq9FHDt/dw/3qzMNVsR0a+Q8r3/WMHu0itzms0zqPsvZzLJ6vQYGPNxeq9Xh
	 3Q7bJPAO58bEoOMT0jaPW0CQr3IO0Q+juSDONZFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0416/2651] PM: runtime: Only queue an idle check for RPM-linked suppliers
Date: Wed, 18 Nov 2026 15:27:36 +0100
Message-ID: <20261118150302.810543957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index fab38bc981139..4d84d97f09c4e 100644
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



