Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062092;
	b=kWYE3ZGdDmJ0MS7l7Va4YuMjkk30acUAj9IHfPbJ4Eaj7J/UHV+nhsUENsT4rs47BRpK
	 /CROX+JC90YcBa6Zwhj8URFuaLTyp9xnQpI2kceH54Fyo979sjbd57jBYkdOG7ii2ZXg8
	 YoGAPZLmGCIitaRQpmUy06aq59+VU7G+Ot2hcnuOw9EhLP0WbFHZFWa9jjJyYQxQS8iaz
	 bkuIqYqNYVEy5nerM/U/1K038t64UBcXO5mComM9gCJ/H/eQDnSohZBdtuk7WiQ3jZ5ho
	 KLIDYtgUH7LI91c/cdakN5Q/3D9RPSw8C8vttmmI8UUNV5IyvaiyAaxrqcV9XaFukmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=GMPIV7xCBxHv7RoI3GK3oxSdm0W3O62xDx/X8tlozuU=;
	b=cWMy+yJP2moEpQwUiUI0RxmtiWBGpdpUPIctK0ugefHLzr6Y2BZsuVQnPOzEUqTy8Wvm
	 xhrZBuQwYlTwsBCYvZacRwDans73V+TDYrFuO5qBsANP7Y22NLfqniCMqvMuM9ERfv/fM
	 WUVtrLmIlwwtR2DSrwGycUTPSI94MhRO6VAam93G74tcPfAsVu0pggCKyvLZfeLbnCEgH
	 kvPUTKZuAkdFhNoDe+mn8vFbeTiHy5spzGy877qINFYEBv+MGLhvzoiWT13ORmfHlIy5k
	 Z0LRe0jKhnV3YI0bap2V4FV/D9jhK9UrI4rOiD1KzFhN8E87cgVes2n44jIyBOIE28Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kc+8XFPv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B1B6083615;
	Sat,  7 Nov 2026 14:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kc+8XFPv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FC61F008A3;
	Sat,  7 Nov 2026 14:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062091;
	bh=GMPIV7xCBxHv7RoI3GK3oxSdm0W3O62xDx/X8tlozuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kc+8XFPvTuV8ADO+RqNiN/HWVAEbb/b+GE3dZGGSw1A4BZKuqoRza04RHCLYQOl7n
	 j+ZDJ53T9c1oSaJaLXVpOb4gH+dZjc2vdikmuOoOx81ybl1rv2rqZ/8ZEij8wTqkqb
	 3bAz9gRU8L9XWSJ6T+izPNixUghdtScQAqnrKDkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1065/1536] platform/x86/intel/pmt: Block mmap when callback is present
Date: Sat,  7 Nov 2026 08:51:21 -0500
Message-ID: <20261107135027.597855770@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael J. Ruhl <michael.j.ruhl@intel.com>

[ Upstream commit 0d4cd92b41dd33a3112959f9be86002ff309de73 ]

With the introduction of the .read_telem() callback, control
for access to a devices data area must be done by the callback
owner.

This means that an area cannot be mmap-ed with the default PMT
handler.

If the .read_telem() callback is present, do not support mmap.

Fixes: 045a513040cc ("platform/x86/intel/pmt: Use PMT callbacks")
Cc: stable@vger.kernel.org
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Link: https://patch.msgid.link/20260910135954.1586360-2-michael.j.ruhl@intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmt/class.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmt/class.c b/drivers/platform/x86/intel/pmt/class.c
index d2f0aea6ea500..072460ad5fa3f 100644
--- a/drivers/platform/x86/intel/pmt/class.c
+++ b/drivers/platform/x86/intel/pmt/class.c
@@ -308,7 +308,14 @@ static int intel_pmt_dev_register(struct intel_pmt_entry *entry,
 	sysfs_bin_attr_init(&entry->pmt_bin_attr);
 	entry->pmt_bin_attr.attr.name = ns->name;
 	entry->pmt_bin_attr.attr.mode = 0440;
-	entry->pmt_bin_attr.mmap = intel_pmt_mmap;
+
+	/*
+	 * The read_telem callback controls access to the memory area. Block
+	 * usage if the read_telem callback is present.
+	 */
+	if (!(entry->cb && entry->cb->read_telem))
+		entry->pmt_bin_attr.mmap = intel_pmt_mmap;
+
 	entry->pmt_bin_attr.read = intel_pmt_read;
 	entry->pmt_bin_attr.size = entry->size;
 
-- 
2.53.0



