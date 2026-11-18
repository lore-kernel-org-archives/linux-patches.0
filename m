Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036361;
	b=Asc7BLuOjaAq9WT1OsRyfLsorilZ4+QoyDJVm8m4WdCOZYkpx4BF0KXrs4LOyOSg5UdO
	 4mqRiIIbazj4PFvC1GfDHZqnehoXpTI0tBUOCC7/dQJARG9F7TeyrScCuOKn89B51JjKk
	 JhnE8R4SSG7fR0wuMV1eNZ6CSks0fOAgqMZMNxlP8ie1VsZM7YyA6EeJujrhh57MJRJF8
	 Anfn9gvFokr7AiOwy6O5avjyI7xRdpeQH0O0CTzyDfwC40abXXyO0sm+awM8NWQwuDS8j
	 glujjcu0eu8If3cj3h9F5SNBA6hOF2TWfm20asvJgROSyIHytDn53y0u3fSNVHxLIRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=joy7FJFWVcXyWm4AHaGmVxWMUTm64gHx5FMTDu6C9bY=;
	b=qpDHWLB9DbmCbFhcfishWIzckGGZyHrNxzGeD4niznS4fX5Kyoorelw5ZG06vvGfTNpV
	 2lGfdHIpMUs+N9FowtQIo9KCZ6mQ+0+wxXZ35Am6VwnpJqUfOrqKHeIN4sYPYarOqNinx
	 syxgEj2lvUGuO9lMJia0mqjf965rWz/0mc/gWS6bT55vCP/F/C7AdSZc6PPPORxb5lqfZ
	 aJbvEBrEV2St4cRfbhs3ff57WOQq44nNdoSkThSWnJ4qTZ2tt9GY8tAriRMGxkjv57TVE
	 ENIsyvJ5hyGjLc512mlstQWP0OT2+a9hF5uJhwe9BahO0mhj4uLyQslUG+137u71sFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XG8szl2R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A057606A32C;
	Wed, 18 Nov 2026 21:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XG8szl2R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4F71F000C7;
	Wed, 18 Nov 2026 21:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036361;
	bh=joy7FJFWVcXyWm4AHaGmVxWMUTm64gHx5FMTDu6C9bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XG8szl2RT3atoIoY9mzD6NVgECF2z8lE7BRPc65IMX0ZEzenTHZ2HoWwa5GzpooMH
	 /XEoNr0DUkXBMrLGmxUJkppyw6AAEV4RNVhKd0x+ck4rk6Oqf9ajeDLBnMfB2OL/rh
	 W+SdO7+oiwopYGRyr1bqAIeKqbgphfLNfOZWxXuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1015/3318] floppy: return the drive state flags from the 32-bit FDGETDRVSTAT
Date: Wed, 18 Nov 2026 15:27:17 +0100
Message-ID: <20261118150350.333928345@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2bffe6830570b..790218836468d 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3603,7 +3603,7 @@ struct compat_floppy_drive_params {
 };
 
 struct compat_floppy_drive_struct {
-	signed char	flags;
+	compat_ulong_t	flags;
 	compat_ulong_t	spinup_date;
 	compat_ulong_t	select_date;
 	compat_ulong_t	first_read_date;
@@ -3787,6 +3787,7 @@ static int compat_getdrvstat(int drive, bool poll,
 			goto Eintr;
 		process_fd_request();
 	}
+	v.flags = drive_state[drive].flags;
 	v.spinup_date = drive_state[drive].spinup_date;
 	v.select_date = drive_state[drive].select_date;
 	v.first_read_date = drive_state[drive].first_read_date;
-- 
2.53.0



