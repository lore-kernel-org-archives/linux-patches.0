Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050840;
	b=wytRJNnTBt7l9R7aAqU0B6hdZFzuyI6fx8vBQracp1cEexMX0A3rbFJgZ3x6xZPnwVxI
	 jAEsgpHGSivScNqUE346Os8MlufjWUQ4XkDgqMCK4RvPCONHuMR6ehKDmGRL+dvhXkoQL
	 sKOFpJ4he7PHq7+vXN0ysujEmn9TQspmLmX5Rx0cHTh4HHd7QcjGpgLRBtkPf6Ko7gCev
	 KZhElyhNfvMZe5tMD+whEhI5GfC97jrN6LLKDRnbkOCTg36+cVBZgv1kMKTwjROyQHcX/
	 xYEeNZTZATUxfHmI1Iso0wdH2kHqlvaS8EJCxBZSzI6eGvfvIQbcD8QbZnkkaNwab6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jL/7s24jgcSQxeqew0RhksvyB40HFT4bFdW8NFtDRMs=;
	b=Nem8wTxIg235+w7zxo0jxc+J1WDgfdleHieYpvQVdV0XaQOBoH2WY+qKOeKzGLV/C5+l
	 PdY4vhiYQUrs53OZA4ZRWmb4rWtVGBgGp3M7qCY6nBdozQAn2wTp/CYo15B4t2S2JzkuE
	 EiHSd+/8hITgTOQlO6ovzW0g62V1Qi2ymIs/cpUgmu49E7PsERUmkJJe/HWpLHwlKDM7X
	 RqDj4nhhWj+ZANA0DIadHchczDGDP77mJOTzMmMgb1EPMDVjGDHgdRTR/U3cTlmC+V978
	 Kxek0FvO3Jd03qKONWcpgGwz945NCDQwkgZa6B0qcWrkNZwdi4536h9oPC2+M53ajdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rsO6BEnQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B571606A32C;
	Thu, 19 Nov 2026 01:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rsO6BEnQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912AC1F000C4;
	Thu, 19 Nov 2026 01:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050840;
	bh=jL/7s24jgcSQxeqew0RhksvyB40HFT4bFdW8NFtDRMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rsO6BEnQIivyTVoMaAldwuBg3OzD0w/F1rja/NjcDtVaNLvkrRhJCYfHffrz22dzF
	 Cb9ZFBa6T+muRr7AmEXcftQDwA2Z0IBSye6qP/ywWaila5poAgLCEJ8tisCSj0ggTW
	 Km8TOYJYX4+5adoXhvwHx65Z6aZMWC6OROAO9Gh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 2852/2857] nvmet: do not return reserved for empty TSAS values
Date: Wed, 18 Nov 2026 16:04:46 +0100
Message-ID: <20261118150344.272209509@linuxfoundation.org>
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

From: Hannes Reinecke <hare@kernel.org>

commit f31e85a4d7c6ac4a3e014129c9cdc31592ea29f3 upstream.

The 'TSAS' value is only defined for TCP and RDMA, but returning
'reserved' for undefined values tricked nvmetcli to try to write
'reserved' when restoring from a config file. This caused an error
and the configuration would not be applied.

Fixes: 3f123494db72 ("nvmet: make TCP sectype settable via configfs")
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/configfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -377,7 +377,7 @@ static ssize_t nvmet_addr_tsas_show(stru
 				return sprintf(page, "%s\n", nvmet_addr_tsas_rdma[i].name);
 		}
 	}
-	return sprintf(page, "reserved\n");
+	return sprintf(page, "\n");
 }
 
 static ssize_t nvmet_addr_tsas_store(struct config_item *item,


