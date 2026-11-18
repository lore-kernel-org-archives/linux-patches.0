Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023434;
	b=uOwuv/tWKtNa190ouLWDyIATFgviYSSPdoXMIqlaOApSY6aGQjfbCuq0xqe4nDZ987pA
	 TkDkJLToOZBuvUN5MQ+EzreqgV+YI6xaOm5eEHQScgUYJUTtzf6ZaTdSXiBJX3aQWk6Fo
	 WRkMHCLkZDe4qzMvV4jtI+sDZt4nEri1KiYyPZmO8fbAXmmjUzHyoxxOenOFsmS4ohERE
	 UsFmO3IS6XP4yarB/KN/mJEUc4c6T6EFvvLgYRdBvFWIzc99wg0UkIg4fLyxTNe9+xrS4
	 bEb4W502A6fgbnoWI0dYd276VFArcpa+6QLbk/PF+3A3MPjeGvBYDaKuXuMfCwRjQgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c+iBnHQQ7X4BRWC5lODy+9x0xm/E69c0Sw9pylgcmnQ=;
	b=KKpdPGDOTJQy36RJ+e63PKIuJAzdW2gK5jcXyeoxcQl0A6CfZcmsyWCnkly8g6e9A8oR
	 lC3plcXZa+cK3ZCd2Xq5HHHLoeJbzabPLQmxKamWlZdyZeb0GRmKjME0oldUJ/bY6BzSb
	 4GITpy+Ys20oHQJOgMO7XkLAgFCdy0ULIONZkkcDVOYKsbodxmwMG3mA6pFKcZY4CMS2B
	 vw2TYnWcgHU73lHAxlXNWjrQQUeBwNW2UfHkxDDkeDtb5dASDb4JgUCq7k3QdFnwidQPS
	 nLVgbBX40wYKOKAk6z9xlWjYrAjA4JC7fanRQdOcV2fY4KfG5YgCfhKVVa0HoWmXN0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUscB0wk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C72B606A32C;
	Wed, 18 Nov 2026 17:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lUscB0wk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DB31F000CB;
	Wed, 18 Nov 2026 17:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023434;
	bh=c+iBnHQQ7X4BRWC5lODy+9x0xm/E69c0Sw9pylgcmnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lUscB0wkdZN0TPxEFwVF0dYJgYvcES267A8rKM+0F0UmnJHMwVAGlrNvTz0WQIBLI
	 AJigyaOx0hZfAmhdjJw9qRM9ePt5klk6mQFKib1RsNDm7Nisr+2wL8m8JxUgKvM+zK
	 hO8RjUCTiSpUkh+YJR4HF8vmah966Hh3B8aPlzQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0341/2151] scsi: mpi3mr: zero out diagnostic buffer status memory
Date: Wed, 18 Nov 2026 15:34:36 +0100
Message-ID: <20261118150134.492779651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 052aea807cfbcefaf5b6ed8202f65da1fc65f4a0 ]

Memory allocated for the BSG diagnostic buffer status is not zeroed before
it is copied back to user space. Several fields in this structure are
reserved and never written by the driver. Use kzalloc() instead of
kmalloc() to zero out the allocated memory.

Fixes: 78b506984ebe ("scsi: mpi3mr: Add ioctl support for HDB")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-16-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 83503c44cc2ac..acdc7c5ba527c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1244,7 +1244,7 @@ static long mpi3mr_bsg_query_hdb(struct mpi3mr_ioc *mrioc,
 
 	length = (sizeof(*hbd_status) + ((MPI3MR_MAX_NUM_HDB - 1) *
 		    sizeof(*hbd_status_entry)));
-	hbd_status = kmalloc(length, GFP_KERNEL);
+	hbd_status = kzalloc(length, GFP_KERNEL);
 	if (!hbd_status)
 		return -ENOMEM;
 	hbd_status_entry = &hbd_status->entry[0];
-- 
2.53.0



