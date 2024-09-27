Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C930118A955;
	Fri, 27 Sep 2024 12:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440186; cv=none; b=Tr1zmZ8ofLqajJAMa+QKvJurv0ZMtJqHwg5oxJUZjXgjxJVWohQi+eeyEmVWKo7I/O1L6N81r84FWYApRV63VaJwciSNMjwKyHLY37CCmpBxT5zE3bmySL+O7XcY47yfS118JbuTc/UAcEjNKXlQwKDOOipaHdRZdD29Rl3r+X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440186; c=relaxed/simple;
	bh=rYmgIAd/NHk98Fo3oUFYRNFMkS65cPuuczcaxWNkuRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gnoc1QGNxIJP+aksBuaSWvit+i6TvDFPbw9Ip8Bqy7iW90GjyNBMJMP2QbVuvOf+PxBhkJZVO43QS1FUPt0NzwjiuJEto7ES/5JT/dSKtNXZhsFtmk20JzqtDYv+2vMm/yGFCgTW+2Xc7YZNlxZWDNEwhtJRLE/R9++5YGgVE6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IwKyZAey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IwKyZAey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53878C4CEC4;
	Fri, 27 Sep 2024 12:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440186;
	bh=rYmgIAd/NHk98Fo3oUFYRNFMkS65cPuuczcaxWNkuRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IwKyZAeyVkBmL4s3lVKLSuwVYnr84MAF8hAlADOg9uDzm/pU+/E55HKeDW9fXGAUD
	 bPu9XZzykaX+lJ3upuiHo388yTKBf2ccogXPZfci3fRKap8vc/LIjo0xvq5Ocl6roB
	 dtr/dlLA6BhUdZZwqEr3jXxQlON8E3w4vzcCCI8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Thomas Leroy <thomas.leroy@suse.com>
Subject: [PATCH 6.10 53/58] Bluetooth: btintel_pcie: Allocate memory for driver private data
Date: Fri, 27 Sep 2024 14:23:55 +0200
Message-ID: <20240927121720.991833250@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

commit 7ffaa200251871980af12e57649ad57c70bf0f43 upstream.

Fix driver not allocating memory for struct btintel_data which is used
to store internal data.

Fixes: 6e65a09f9275 ("Bluetooth: btintel_pcie: Add *setup* function to download firmware")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Thomas Leroy <thomas.leroy@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel_pcie.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1208,7 +1208,7 @@ static int btintel_pcie_setup_hdev(struc
 	int err;
 	struct hci_dev *hdev;
 
-	hdev = hci_alloc_dev();
+	hdev = hci_alloc_dev_priv(sizeof(struct btintel_data));
 	if (!hdev)
 		return -ENOMEM;
 


