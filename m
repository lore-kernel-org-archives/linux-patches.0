Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062208;
	b=4pzfOXeETacTBf0eQiVWPLl4tAnhoZxjcWdSRvh0YsY+UmiC6nURyVcup3Zs9QgagOX5
	 TpYrfWCtQ56CXI+98/c40k06OslPyatM6dFfJDd/0fO7okRI7GzS49MlwzN/DKh7Av5s/
	 7su16t2hC/C49ES23UzQSDSBE+kfgMdf0znyAMsfVD5t+XSwvvHRKoq9+kEmAT0SVyG0j
	 S1XyFy8ot6L0rGu7apnsx5gqzq9ui5O/YooKsUUzuqqUp4dNXIjDIlL5UVVpLnRWRYAxM
	 1YfQ1Bq4RBLGIpGQBMIq0GKSKFUUHxHdxP6fwROW+c8es/y7Zkhrk109u+SqGOvur4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fhXE+3WTfHQyefIi4xK2hMOOluWbVG99EY5QSp8HbUk=;
	b=mQseUTEcxZ6E/vO6EA8gDmGKwlIyfcg1B0yj5oLZmz0Vc8iYJvGwJKtdIbRSSjkH29Jo
	 YUgV/sKDWmGRsPmKKNqhUGA43LrN8P826ROJGZP4x+DXHq8eI1I8tB/0yX0/pfED0dcYz
	 w6AuKeKKRUSqgxkag/JGR7MK8YinrQZ/ahSn2M/tkF8s5h/r+uCciUHccc+0gJHZWCzFU
	 Abw52iBSzTiQM2h9VekgSSbIlYFDsUIgCyokp6ndI811l3eZOm8xu8RsnbbBcTWi+Eq5U
	 f5aWVwoKu2SDWVBJoQ1YHdjeS9AU2Zb/WhkuXU2oUyS1k9EL/pN9g4nOWYlN2PAF/3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nnxz77z5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA010606A326;
	Sat,  7 Nov 2026 14:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nnxz77z5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AF21F0089F;
	Sat,  7 Nov 2026 14:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062207;
	bh=fhXE+3WTfHQyefIi4xK2hMOOluWbVG99EY5QSp8HbUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnxz77z5pUZq8PkTWhB+tdwUYyxEeoU8pmd0JJsdY9HeEB3OrdgSDJ6Ow/RXDLwvp
	 GF52drUdKRvNpKjnCv5XEfeacfywP1UqNgdKqweFJzj4gWaDWdaG0zWOMv2E5UEHWV
	 zvdQ8Sz3cBP2Bh1zNkl0KrPlfc4pXzMZe8YYWqzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1163/1536] floppy: return the drive state flags from the 32-bit FDGETDRVSTAT
Date: Sat,  7 Nov 2026 08:52:59 -0500
Message-ID: <20261107135030.395591000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Efremov (Oracle) <efremov@linux.com>

[ Upstream commit bb38473f1bcb287567f2fa7980e483a778092504 ]

compat_getdrvstat() copies every field of the drive state to a 32-bit
caller except ->flags, which stays zero. 32-bit FDGETDRVSTAT and
FDPOLLDRVSTAT therefore never report FD_DISK_WRITABLE, FD_DISK_CHANGED
or FD_VERIFY: i386 fdutils (floppycontrol -P, fdmount), and other
32-bit users see every disk as write-protected and never see a disk
change. The compat code in block/compat_ioctl.c copied the field;
it was lost when that code moved into floppy.c

Also declare the field as compat_ulong_t: the 32-bit struct
floppy_drive_struct starts with an unsigned long, and a signed char at
offset 0 only lines up with its low byte on little-endian machines. The
size and offsets of the compat structure, and so FDGETDRVSTAT32, do not
change.

Cc: stable@vger.kernel.org
Fixes: 229b53c9bf4e ("take floppy compat ioctls to sodding floppy.c")
Link: https://patch.msgid.link/20260924112825.3525931-1-efremov@linux.com
Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index b224b2ddc110c..56e9901b4b468 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3607,7 +3607,7 @@ struct compat_floppy_drive_params {
 };
 
 struct compat_floppy_drive_struct {
-	signed char	flags;
+	compat_ulong_t	flags;
 	compat_ulong_t	spinup_date;
 	compat_ulong_t	select_date;
 	compat_ulong_t	first_read_date;
@@ -3791,6 +3791,7 @@ static int compat_getdrvstat(int drive, bool poll,
 			goto Eintr;
 		process_fd_request();
 	}
+	v.flags = drive_state[drive].flags;
 	v.spinup_date = drive_state[drive].spinup_date;
 	v.select_date = drive_state[drive].select_date;
 	v.first_read_date = drive_state[drive].first_read_date;
-- 
2.53.0



