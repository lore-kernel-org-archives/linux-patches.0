Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829551;
	b=apVmjrU4vqdp3yWr/jIIUby6FDzkO2xmqDSEFMcvhX/x0BzgxXIFYPBxPdgaRMoRqjFq
	 5nEoS1gX6bmv7KllpNd/GNA1lm4Lr8YlFnXLQgCMtIxFafkr08fdP6KuPImDdUTrAiM9W
	 XxyFCs5kcjT62EfuRFZCDAXViBteJqBS9pOC4q3Xc2QgYtkQi7wyWZecRf1/QohLnpKtb
	 xNF6gJbxRSP7k0J+IM0tdPZ+vTtxDWtcIzvx+f0Qp8+yCuCGefJgqKuL8jJB3NRh9C/JE
	 eNCIJxw03AQKD0p3WQ2YThIBKuqded/tCm4BZxQMDKtl3+1c2W5my3KBQjpXGgObNJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FCb/WaSdtpZHz6ocV0ibxepH0XEjdkIKx9KRv0Tpx+Q=;
	b=Mu550SX9MNKmfqgjBnf9fvQbZRzoeFTm+oWWz700vkjPLYRukCxstpRQZu0SeUdPOJ8q
	 VVCg7j2dZLbQu3PJOc2UNqwrFF2x8vHmSvr7AmNErFa14C3u/A9Vy+KPq6lyrW0nmjPWB
	 QY5gI3gavG7ZNWheE/Vh/jaxmtBa60qNUjvQWmHFhcNEStilAK+0kGztLJ56FbneckT4W
	 /abMo+fYa+XlPk1MFdmmxaeKxbPXcpN2OHYsjgdf5AF+SrdKou8Pl/Dg+pqbV3+T1c7nJ
	 aG36GvpQBjAlyVlS3ZV3B1CbM3CAO2TgurWbPezRY/l4GDWqZqQRDWhOk/LKJuLj5rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eWJIY0+w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C5B606B2C0;
	Wed,  4 Nov 2026 21:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eWJIY0+w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DD31F00A16;
	Wed,  4 Nov 2026 21:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829550;
	bh=FCb/WaSdtpZHz6ocV0ibxepH0XEjdkIKx9KRv0Tpx+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eWJIY0+wDD1iQVu746DOJgW+eTMCzfquFc0CbbWSMCZgaGaX+tYV/OXgTNCdK8MWE
	 PCTqqI+kwbOSHOjQ9Sp1nH05LxODhBgAeqhy9uO16nZbY2bRRJIq50tNtxomiEUxmz
	 1JRuGgBQnMJqd1PoChMnKd2VR91W4+KfuWh09ADc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0197/1005] driver core: attribute_container: Unwind device_add() on attr failure
Date: Wed,  4 Nov 2026 15:58:50 -0500
Message-ID: <20261104211049.314031983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 8cfe7ad274bb42c4653b645267410d4a3a23db98 ]

attribute_container_add_class_device() first calls device_add() and then
creates the container attributes. If attribute_container_add_attrs() fails,
the helper returns the error with the class device still registered.

Callers use an error from this helper as a failed add and do not call
device_del() on that path. Undo the successful device_add() before
returning the attribute creation error.

Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://patch.msgid.link/20260608172717.88657-1-dbgh9129@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/attribute_container.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index b6f941a6ab693..b1d6eb6ab46b5 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -427,7 +427,12 @@ attribute_container_add_class_device(struct device *classdev)
 
 	if (error)
 		return error;
-	return attribute_container_add_attrs(classdev);
+
+	error = attribute_container_add_attrs(classdev);
+	if (error)
+		device_del(classdev);
+
+	return error;
 }
 
 /**
-- 
2.53.0



