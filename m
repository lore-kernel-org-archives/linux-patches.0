Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617720;
	b=VaW7NswfI2dOLpXjA4WG+tjqbOEMmISVDpEpdAK+2aKcXj9ELor4XsODKCh/2fBF+ytW
	 3ycpdvTBknBnAkszXTleH7qZ2W1pyUAlJ1JwCeElwk5BSssl2U38xiYexZE8yNtm/6uTM
	 vkGc1Ht+pRLMgf8ZMUsarAcMxK0f/C0jM9EZRHniOH05PsUUZ3eH+ClkYCPycmQQB+s/u
	 ymyWrFw9ORXqWBghufpVNi1/BNwQgoLh2wDqYHBTd9PVsDn3T/qxvsFzwJcTU3VUppXGZ
	 n24Fa8utUhhuLij2RiLrXI4pELMTMUTqFa+O/6V23ZTOeR8t9wSN6YiwgxKFz8MVQ6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eCUiFgi8QwYEXN6x3EX3gZvSDw+CF7D/5EA3VsbBwiI=;
	b=cNMNZ/R1iZqQ8dL0HVkheWODYPOEe+IGSe6zICs1FDUDgqCZlp38HYL1SA3I3U3yBe5v
	 jomy1/FhGOr6Ij0oggKz647nHcYt8bscquAUcB7/SZqbMtilXkTh1tTsBW/yNcPS4su+F
	 RoXKU/QhLLMXDus85xWdgVoDMek0rPZB9djlpM3nriZISMZpEC3qKxMpbHifUK3komfJU
	 OWbcT3ynSqZ9BDLgoDvCyB/i/gOy/xxqTeI04kZiLEAwQ9CUyFvklctNzaV8PJXbvdX01
	 H5kYfwR9TQGBHi5/4dMpVPU9WBj7byKju+HY68mdYN59BqPQNP6+uFnYtNbV+GWPm5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c7Jg4UQq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C01606A326;
	Wed, 25 Nov 2026 14:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c7Jg4UQq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98601F000C0;
	Wed, 25 Nov 2026 14:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617719;
	bh=eCUiFgi8QwYEXN6x3EX3gZvSDw+CF7D/5EA3VsbBwiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7Jg4UQqrdLWVVkfKq0TiJAINHMJ652+TJResI+3/m2jl8mN1s39yiJUuQ9Uv+3oM
	 FCbKaY1legq+RPqle8Spnqh8ACQ2ITonA+yF74V7uCbEfpIv+tNTxEsCHYS9j7lOn+
	 5pWMHiZFSZ5RF2Eka9cVqB/szeyabKEIW/LekFt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Piscitelli <ooonea@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0052/1005] scsi: scsi_debug: Drain target cleanup before module exit
Date: Wed, 25 Nov 2026 15:23:10 +0100
Message-ID: <20261125143822.959853596@linuxfoundation.org>
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

From: Giuseppe Piscitelli <ooonea@gmail.com>

[ Upstream commit 34c99ce2993971712d89010a948d2f650687b796 ]

Target destruction queues cleanup in an exclusive async domain. The module
loader's async_synchronize_full() does not wait for exclusive domains. Wait
for target cleanup after removing the hosts and before removing the debugfs
root and returning from module exit.

Fixes: b402a0dce64a ("scsi: scsi_debug: Fix create target debugfs failure")
Signed-off-by: Giuseppe Piscitelli <ooonea@gmail.com>
Link: https://patch.msgid.link/20261026202342.668361-1-ooonea@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8290feadc212b..232b4eccd5a11 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8723,6 +8723,7 @@ static void __exit scsi_debug_exit(void)
 
 	sdebug_erase_all_stores(false);
 	xa_destroy(per_store_ap);
+	async_synchronize_full_domain(&sdebug_async_domain);
 	debugfs_remove(sdebug_debugfs_root);
 }
 
-- 
2.53.0



