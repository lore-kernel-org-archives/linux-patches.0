Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82116187325;
	Tue, 10 Sep 2024 10:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965178; cv=none; b=SaOafm5UhzkvCi4Ni/fS980a1S/TJGrm1tLP6qSDFdq98wnI4rWmZ2znmY3h7Vc6tmqHK8a5FtkQdsfTUbstBcUvAZ6GosfrFtzHH4E9nKzpM9hxdKSl8HD9hcU50MsG6l0mKoLxsIFzt6FFa+EsYIzF5fslb3lOKxRhBGsFvzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965178; c=relaxed/simple;
	bh=2FnLqUclLcit0gnAtWXiJhiLh44/vLnb+OE+CYqHVv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utNSlXhLhVCXKo3/VYObHED0DSFaVd9aVdOq0RI8ieJO4sNP3Xu77OFhb7BnttlCV/QMuiuyHS72kT8AYBdVhq7kXViNqwhFfgXIct4z0G1bbtLVr8Gg16tBDjSnjJrTgaD49ZfERS6aVpD3PFrtwnLKSbiZ22MuFQzcxn4zA3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLH8z0ql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLH8z0ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01549C4CEC3;
	Tue, 10 Sep 2024 10:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965178;
	bh=2FnLqUclLcit0gnAtWXiJhiLh44/vLnb+OE+CYqHVv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLH8z0qlcnmOhc+unJNyS4GoVj9z6FdMUqHVjCeyJ/eu4qA4I3jq+XvALH++jQaYx
	 E0zTwoCfbXxLGTIM2rAsHfi3OGHu64EgWAcbbabvjbkUUURXYEfxfiKJQvSpvbbwmK
	 +5N0TsW1lCd9NkDtR3FcOu3pMdyTcBk+aNClVZO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.10 164/186] nvmem: Fix return type of devm_nvmem_device_get() in kerneldoc
Date: Tue, 10 Sep 2024 11:34:19 +0200
Message-ID: <20240910092601.363241244@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit c69f37f6559a8948d70badd2b179db7714dedd62 upstream.

devm_nvmem_device_get() returns an nvmem device, not an nvmem cell.

Fixes: e2a5402ec7c6d044 ("nvmem: Add nvmem_device based consumer apis.")
Cc: stable <stable@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240902142510.71096-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -962,13 +962,13 @@ void nvmem_device_put(struct nvmem_devic
 EXPORT_SYMBOL_GPL(nvmem_device_put);
 
 /**
- * devm_nvmem_device_get() - Get nvmem cell of device form a given id
+ * devm_nvmem_device_get() - Get nvmem device of device form a given id
  *
  * @dev: Device that requests the nvmem device.
  * @id: name id for the requested nvmem device.
  *
- * Return: ERR_PTR() on error or a valid pointer to a struct nvmem_cell
- * on success.  The nvmem_cell will be freed by the automatically once the
+ * Return: ERR_PTR() on error or a valid pointer to a struct nvmem_device
+ * on success.  The nvmem_device will be freed by the automatically once the
  * device is freed.
  */
 struct nvmem_device *devm_nvmem_device_get(struct device *dev, const char *id)


