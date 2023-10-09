Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52141A71F
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmWDQext"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11746C433C7;
	Mon,  9 Oct 2023 13:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858439;
	bh=x4AkC3jP0L9qnrvyuj3kzwRd+AOHQxfxa9esx1vNwF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EmWDQextwtHg12m5s+MrXtrZ1UbIMTgt/2Xcb7h7rfhfHfGoFJI5ekLMyETsjvn4Q
	 Okq9wxUCwlZGFYnQIcHgQ+1AujJT+vrVCBIsPrrbzxqzRsvmJzIL5J/bwRjeGy3zTU
	 /77S08/D8yVki7ZxGTGerKgfNfSI7ow7b2Z7jcgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 5.4 122/131] IB/mlx4: Fix the size of a buffer in add_port_entries()
Date: Mon,  9 Oct 2023 15:02:42 +0200
Message-ID: <20231009130120.159786355@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit d7f393430a17c2bfcdf805462a5aa80be4285b27 upstream.

In order to be sure that 'buff' is never truncated, its size should be
12, not 11.

When building with W=1, this fixes the following warnings:

  drivers/infiniband/hw/mlx4/sysfs.c: In function ‘add_port_entries’:
  drivers/infiniband/hw/mlx4/sysfs.c:268:34: error: ‘sprintf’ may write a terminating nul past the end of the destination [-Werror=format-overflow=]
    268 |                 sprintf(buff, "%d", i);
        |                                  ^
  drivers/infiniband/hw/mlx4/sysfs.c:268:17: note: ‘sprintf’ output between 2 and 12 bytes into a destination of size 11
    268 |                 sprintf(buff, "%d", i);
        |                 ^~~~~~~~~~~~~~~~~~~~~~
  drivers/infiniband/hw/mlx4/sysfs.c:286:34: error: ‘sprintf’ may write a terminating nul past the end of the destination [-Werror=format-overflow=]
    286 |                 sprintf(buff, "%d", i);
        |                                  ^
  drivers/infiniband/hw/mlx4/sysfs.c:286:17: note: ‘sprintf’ output between 2 and 12 bytes into a destination of size 11
    286 |                 sprintf(buff, "%d", i);
        |                 ^~~~~~~~~~~~~~~~~~~~~~

Fixes: c1e7e466120b ("IB/mlx4: Add iov directory in sysfs under the ib device")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/0bb1443eb47308bc9be30232cc23004c4d4cf43e.1695448530.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx4/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -221,7 +221,7 @@ void del_sysfs_port_mcg_attr(struct mlx4
 static int add_port_entries(struct mlx4_ib_dev *device, int port_num)
 {
 	int i;
-	char buff[11];
+	char buff[12];
 	struct mlx4_ib_iov_port *port = NULL;
 	int ret = 0 ;
 	struct ib_port_attr attr;


