Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703307BAFE;
	Wed, 21 Feb 2024 13:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522503; cv=none; b=MsVBi2tCbrbZSvIadUOq3H8RK+zXj8iOJSeSuLXTWL0Ug2of6aO3fYWjyNomRPHeW+JPISxItgJm22/tsfmzPlujdkaba7u/fISO8UjFsA+ZIgCVQkr2IF0DfOKlpu9uB/gRhqb/11+L1DcKA035dhBaaK0Ot3BBGHuFuufdRNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522503; c=relaxed/simple;
	bh=+/BHgB1vC0VOYbRLstfz8y7VyJ2R82FtK3l57tu89MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXztEOu1STVTcFHrRXybtEtvPOj9Jz9EbsI4F4ks4EprezGMhb7deddTQtuu3ighLIvduYdwrlKIc9uZVb7ogh7LvUzDPIN/dQaI0I5ToGL/9UH9TQwMoBxZP8gv+OsygmOJRqQUFd0Y6MpzQac084XmHUB5NVldZWmB/rXjIT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGrWTKGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGrWTKGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9114EC433F1;
	Wed, 21 Feb 2024 13:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522502;
	bh=+/BHgB1vC0VOYbRLstfz8y7VyJ2R82FtK3l57tu89MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGrWTKGOAh3VhFLNWenSy6QKkPUDsIsNrqQdpH4mLu2jvoqGw+4IZRVz5NENrpmKh
	 g6ayi2+xFmrf2kevh8UPQxBPYDSWQeey39wxnpj6c6zNwfYSAqf+jZ+L7zoZCSsN8p
	 g9oQZ6A2kzHRvZ6Wr0gA7sktHuRx4SUE/oZP8cTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Thomas Bourgoin <thomas.bourgoin@foss.st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/476] crypto: stm32/crc32 - fix parsing list of devices
Date: Wed, 21 Feb 2024 14:03:22 +0100
Message-ID: <20240221130013.512309158@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bourgoin <thomas.bourgoin@foss.st.com>

[ Upstream commit 0eaef675b94c746900dcea7f6c41b9a103ed5d53 ]

smatch warnings:
drivers/crypto/stm32/stm32-crc32.c:108 stm32_crc_get_next_crc() warn:
can 'crc' even be NULL?

Use list_first_entry_or_null instead of list_first_entry to retrieve
the first device registered.
The function list_first_entry always return a non NULL pointer even if
the list is empty. Hence checking if the pointer returned is NULL does
not tell if the list is empty or not.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202311281111.ou2oUL2i-lkp@intel.com/
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202311281111.ou2oUL2i-lkp@intel.com/
Signed-off-by: Thomas Bourgoin <thomas.bourgoin@foss.st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-crc32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index 90a920e7f664..c439be1650c8 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -104,7 +104,7 @@ static struct stm32_crc *stm32_crc_get_next_crc(void)
 	struct stm32_crc *crc;
 
 	spin_lock_bh(&crc_list.lock);
-	crc = list_first_entry(&crc_list.dev_list, struct stm32_crc, list);
+	crc = list_first_entry_or_null(&crc_list.dev_list, struct stm32_crc, list);
 	if (crc)
 		list_move_tail(&crc->list, &crc_list.dev_list);
 	spin_unlock_bh(&crc_list.lock);
-- 
2.43.0



