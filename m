Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063141;
	b=BJrE9urr+K2MBa2jUbMWB/NecJVG6D+7MbUDO5qeEmhm2kZZ0vCWKBAoQSvJM/VfvUCS
	 J2UZhAaEyVLM0io+/ZChw5M00og2S1ygAg45YcYZJmZ8jlTVlIGm6AaamhhHHRwu1cupC
	 c/ImugHGdB3hYpcQv4JUTFSOc74tzHH/rjGAKQ7Rzr7osfZ1GbHyN68PzeAHvMqB/4o8f
	 AaaF5lHMcf1qKq0JIjFXLJC3FQZU5p67i2UlPwSfn9oTO4tskbN2v7edH2KZot1zj9dED
	 ecs8OEZCdmO5YJ6ilmB3gkdOqqN5OALRv1gJjmQcay5XPwrvt/dkQFzgxqHKHt5bO6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=//fJ5e78RkwhCynOS0ync+j+LTElWbGH64cNyTgjAfQ=;
	b=c2ZV++FFUelbiCWl7w2xUMu6LlhEPqLsgKIBeJ22hpMldd/Sxael/8dMXLIjKbndPk1t
	 VxLec5UzQyuRkq3Vz62+8/ZENC9I9KtnEzAOKW2sm4626jiDPYmPlil+BXfEwPFod6hg7
	 DjAJ9LfoH8VZ3CUTGUdLIQjN2gRLr+GC/YzsuOkeBS9xpE4Uts+Drx75zh57G1XBWoh1U
	 zsTMZQkDEf7vfHT/JmLzW9idhk21mUY4HWgxz0FhPv9p32cBmpAQWjFKCFuCvbG65fAEn
	 p7IRaJAu3IUuQjYnovx7ssElvyJsZebWkBZauC++8FviQaDyhzdrJvvCjaQ8FUp8sWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xG7Uefb7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADFD606D805;
	Sat,  7 Nov 2026 14:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xG7Uefb7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064191F008A1;
	Sat,  7 Nov 2026 14:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063141;
	bh=//fJ5e78RkwhCynOS0ync+j+LTElWbGH64cNyTgjAfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xG7Uefb7tcEJIPSuTi4rlJ+OT6fKGzbGEjUpGXRe4ft6XjNKeGauRA85wS+lz1Z5j
	 y/4htrW06lveccZOGhtksTubwdkV0HHOM40Qm/nkP/WzMwHRj6O6sr8iru9n99lc00
	 ACPRJOQ6HtEPqIC+09d2+88t/2ZbmCKlINzxOWw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 369/869] floppy: return the drive state flags from the 32-bit FDGETDRVSTAT
Date: Sat,  7 Nov 2026 08:50:51 -0500
Message-ID: <20261107134905.284504699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 3ec5453672c15..eed7de727e547 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3602,7 +3602,7 @@ struct compat_floppy_drive_params {
 };
 
 struct compat_floppy_drive_struct {
-	signed char	flags;
+	compat_ulong_t	flags;
 	compat_ulong_t	spinup_date;
 	compat_ulong_t	select_date;
 	compat_ulong_t	first_read_date;
@@ -3786,6 +3786,7 @@ static int compat_getdrvstat(int drive, bool poll,
 			goto Eintr;
 		process_fd_request();
 	}
+	v.flags = drive_state[drive].flags;
 	v.spinup_date = drive_state[drive].spinup_date;
 	v.select_date = drive_state[drive].select_date;
 	v.first_read_date = drive_state[drive].first_read_date;
-- 
2.53.0



