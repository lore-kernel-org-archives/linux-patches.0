Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212649;
	b=k6nc/x/w6uXvVUroYTwVeBwz+0cLFpOoarVTGvpHHivUmPMHRFWwYz2DOXJCemNiTcFz
	 gZuMSHsWgCIG5RTxbpOPQQADVyd9UP1u1McVXyvQKTo1dKPQ7XvHCIWZaEnBgP+rHbj+f
	 il2AE/H6WUjyhTleIIYwzt+k7ERf+jaJenG/GVSMBO+Zui9gKBRhZ0klcV8mexULc1Jpl
	 5Ww7zm4ZjQMcrfzOZoqD/f1w0mwpp8DYBIvgddKGmGsNlR3zH2nYkLMeCjm4CCZuc4h5G
	 DbxniwFMu480wirHn1FX8XOrje4BzDyFIkN5iTp/HuZhbblSCsG2WitVmyh6bcrqHgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7xds1urFs14OqIlinJiCQP1QGAwq+NHaC8uUVo7Wleo=;
	b=hkV7UghG+Ef6LA7oRMRcwsI3eKvPQcvfgwtSpZwu0G3bl0qNFiYgtY6QSA9UjrS9OeVy
	 I/pBtz8PITs7Onh/upADbW0j1FqxzbscSR3mkhkjvnyblGSBQAR4HDvV5eS3H4ED60eMH
	 Y9RxU0nH0ZioA5gFQTWfHi/9djdG3bRmcy/vKFxnX3Lvdj14albG3xGtIPnjqInmWQXyT
	 oyZlLeTSla6BQ+IfbOnC+IbjyABbguvh4RHA0uQLXCsT7IHfwK77H89mtIBry1q/qUW1W
	 rYzYMB2vOfy+4SyEYJsHjHwuvzFy4J3HLXKpEJnfwwiHn4wdzy/tRnDy4txUPbaQodA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z86HHgGE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980BB606A31A;
	Wed, 28 Oct 2026 18:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z86HHgGE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B751F01825;
	Wed, 28 Oct 2026 18:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212649;
	bh=7xds1urFs14OqIlinJiCQP1QGAwq+NHaC8uUVo7Wleo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z86HHgGEccDyCxy41xseu1PuQLZUha4ZzXRXLNM0VYjfBXYCCjowyApk+V6RVwQqx
	 3zZn7W0Glu9BHMGr3W55YMYiT0bWYYehsXkIUSl7soos68Y66gWsrBaExmaT/MdGnP
	 sM0RA6LMJRLvrvTcvViFCLhSWkKHQGEnHKpLe4o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0228/1887] Bluetooth: hci_core: free the HCI ID if naming fails
Date: Wed, 28 Oct 2026 17:38:44 +0100
Message-ID: <20261028170504.422277545@linuxfoundation.org>
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

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit d1ac915fb4184faad1b62148be50f317de7c24b5 ]

hci_register_dev() allocates an ID before calling dev_set_name().
If naming fails, it returns without releasing that ID. The device has
not been registered and hdev->id has not been assigned, so the normal
unregister path cannot release it.

Free the allocated ID before returning the naming error.

Fixes: dcda165706b9 ("Bluetooth: hci_core: Fix build warnings")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Reported-by: Changyul Lee <lcy8047@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 056de77b4adc4..b9175d7453666 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2596,8 +2596,10 @@ int hci_register_dev(struct hci_dev *hdev)
 		return id;
 
 	error = dev_set_name(&hdev->dev, "hci%u", id);
-	if (error)
+	if (error) {
+		ida_free(&hci_index_ida, id);
 		return error;
+	}
 
 	hdev->name = dev_name(&hdev->dev);
 	hdev->id = id;
-- 
2.53.0



