Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057053;
	b=e7Gvp3KYRZzrPEl9rDRal1bbyHUJJrhRro8Rvi5SAXb8jlBPr6Kvo8livOeW4+t0m6SM
	 9NNkIdVD0P9DkzCCoewvi2T7FYi3RfTJle3zJ/W6uKfOmp4zVgLfFkA3RnZQtQMMSER+y
	 dlZXVu8P7r7PtYazD6gaFKUqqoqSukXlKJn6LnuGwsII8FDFQu7ZvhqB6mYxvwW8wkqW3
	 Mx0b3Rk0US0MCqpQ/bokHeXdeiAhP7LJs+rxR9mwyvbu/ohkKQe0jDfcvgDzN9co660j8
	 ZwAu0M3tFyUlf8hdoDqsqoQvVShmu1ST35B+m/hfCZjkHT04XqO/uqPy/q1s5e05DLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LLR5zeZ3OI60DSo5YaO0ECgMtKQD5mG3xAn6OmRFpHE=;
	b=f5FCTgkVksRO9ElQUUwwvHeVhOdx5wr3gj7Z2MKe4oKXcQNgFqUJZYd79/ZcBlZDa3xi
	 BNqJjQASV1uZ8PGu7LnavTQAJ24lm5ZuL4wZznfb88I5w4Lo0mf/Ux14G267541kyBTKj
	 e5dzW0orOTPyV6SEE5LJ1FhayjoenMVa7L6PxNuqJP0uW5gfVklZFQo5MOojCpDDsI+6U
	 wM13Hr3zlgPopM2rB2+SasV+mnqmUHJTpPTphg4kSFRbyXd/1IxpaKzf02he2/XuEGXDC
	 m/0oXeqgTOGVXCcAz5T1M7iKsxet8SPd45ituOjO9HnhEmpELa9mxm3Uue468NaIeog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRUsEtSk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959C6606A31C;
	Thu, 19 Nov 2026 02:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRUsEtSk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FCC1F000C4;
	Thu, 19 Nov 2026 02:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057053;
	bh=LLR5zeZ3OI60DSo5YaO0ECgMtKQD5mG3xAn6OmRFpHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gRUsEtSk/Ebx40Mh+D8X5ONuIuWxTPSRILCaW43AIpOg+M4b5OEA+R2UYuyL5604/
	 aYFyhkX+dZ8SC2q8uUFf4FFf4jdGq/OLubtDrBSyWvVFOzAr8mEmv2swzPkXeRR4Sf
	 VuZyloL9m5F7zP7gOmJ4uiii7QkXo2Spb81RzY2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 2205/2214] nvmet: do not return reserved for empty TSAS values
Date: Wed, 18 Nov 2026 16:04:41 +0100
Message-ID: <20261118150138.482788894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -371,7 +371,7 @@ static ssize_t nvmet_addr_tsas_show(stru
 				return sprintf(page, "%s\n", nvmet_addr_tsas_rdma[i].name);
 		}
 	}
-	return sprintf(page, "reserved\n");
+	return sprintf(page, "\n");
 }
 
 static ssize_t nvmet_addr_tsas_store(struct config_item *item,


