Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065245;
	b=slejSSXXdryM6D2bZx3mUQU/JCLURIkJSn/sBwG1HtWNttWFZU1RBxNshiSk0osciFMR
	 +5drYJCifRaka5cF7UxBXIYSQvqbu5lMQV5UFNrH1v3tON6q8hsv6H6z+yJZumMOFBFIV
	 gkoyXAd2NJgoReQp6qxWl/ra7s4EUbOPZTt9Q9iQKiH7mIEEB+zOAnFR0QGmQKs0hL2ei
	 XfSQRU14JhqUSju3tu3S1oX+6kFMaMtuYTNCnN3jNYVeyOUdJgnQpCJgLlClfzQJOJKXk
	 t33ro0Rqyub7NxvmDiBIKFk9UVc5xKnBMAIBal8gL28ytm8d0rj+7Pjt6p4CNWKBO2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065245;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zQ6QCzBKlaVO6x/QVzCEgyS4kG6y1zDqAHoQCHbKfyM=;
	b=wFBxn5Zm0jZhIHd6qVhKVAruTAJxY23B7e+l1yfkUzOD6q2yy5P3HUtvzJiq8iSgTYjb
	 vxV0YyfzFmeWjGF74fn0dt8MqaNs71CkI4mgteuAlEpCSii6/jxtn8TVHDlgTXnkA0ivy
	 yZ8vj96AjqLuYE0uSrpbhF8F5ZGKAzqlKvRntBx4EL/RzPBUQZEncVoBHF/BbOnb9bVcJ
	 cv9SveOa4/LglA2u7zwjsok30VrMY0AjxNzyEfqgRdeYVpX6v3eRkRgzPZrjoC5iZlXAU
	 q7VVi4uyinOhVrkRLyGd/AwZx+VSS5plHDt2zVaH95mFtjlISUdymu2r/rFrqFJzQhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+LskTQ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0294A606A32E;
	Sat,  7 Nov 2026 15:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+LskTQ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238471F0089F;
	Sat,  7 Nov 2026 15:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065244;
	bh=zQ6QCzBKlaVO6x/QVzCEgyS4kG6y1zDqAHoQCHbKfyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+LskTQ0A64LNjMXf/d6m995OjuWmEBJGleVpS7j/RfCbVin5n25fqYEEsxqMh0+2
	 4ZVEIhbziJ3zJmkxTEgHOgJ3RGJq4urfwfebQLlyJn7kGqwGJasArwQMsZxCCCSqSJ
	 +gnHwAFOu9w/dhvrqzsKs5YGYdjZQALmT/emAzh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shaos <shawnq1@163.com>,
	Jeff Layton <jlayton@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1021/1257] listmount: dont wrap around with a U64_MAX cursor
Date: Sat,  7 Nov 2026 08:55:17 -0500
Message-ID: <20261107135007.529836735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 95a5412022e437691f4eb1924ff249d9044f5ed1 ]

do_listmount() takes the last mount id the caller saw and looks up the
first mount after it by searching for last_mnt_id + 1. With U64_MAX
that wraps around to zero and the search finds the first mount in the
namespace. So a cursor at the largest possible id restarts the listing
from the beginning instead of ending it. A cursor of U64_MAX - 1
correctly returns nothing.

No mount will ever have that id. Mount ids come from a counter that
starts at MNT_UNIQUE_ID_OFFSET + 1 and a caller that only feeds back
ids it got from us can't hit this. It's still wrong. Nothing can come
after the largest possible id so return no entries for it, just like
for any other cursor past the last mount.

The reverse direction isn't affected. A cursor of zero is special-cased
and anything else is larger than MNT_UNIQUE_ID_OFFSET so last_mnt_id - 1
can't underflow.

Reproducer, unprivileged:

    #define _GNU_SOURCE
    #include <errno.h>
    #include <stdint.h>
    #include <stdio.h>
    #include <sys/syscall.h>
    #include <unistd.h>
    #define LSMT_ROOT 0xffffffffffffffffULL
    struct mnt_id_req {
    	uint32_t size, mnt_ns_fd;
    	uint64_t mnt_id, param, mnt_ns_id;
    };
    static void list(uint64_t cursor)
    {
    	struct mnt_id_req req = {
    		.size = sizeof(req), .mnt_id = LSMT_ROOT, .param = cursor,
    	};
    	uint64_t ids[8];
    	long ret;
    	errno = 0;
    	ret = syscall(__NR_listmount, &req, ids, 8, 0);
    	printf("cursor %llu: ret %ld errno %d", (unsigned long long)cursor,
    	       ret, errno);
    	for (long i = 0; i < ret && i < 1; i++)
    		printf("%s%llu", i ? "," : " ids ", (unsigned long long)ids[i]);
    	printf("%s\n", ret > 1 ? ",..." : "");
    }
    int main(void)
    {
    	list(0);
    	list(UINT64_MAX - 1);
    	list(UINT64_MAX);
    	return 0;
    }

Before, on 7.3.0-rc7-00252-g4e3259b08c54 (vfs.fixes) in a VM:

    cursor 0: ret 5 errno 0 ids 2147483651,...
    cursor 18446744073709551614: ret 0 errno 0
    cursor 18446744073709551615: ret 5 errno 0 ids 2147483651,...

After:

    cursor 0: ret 5 errno 0 ids 2147483651,...
    cursor 18446744073709551614: ret 0 errno 0
    cursor 18446744073709551615: ret 0 errno 0

Reported-by: shaos <shawnq1@163.com>
Link: https://lore.kernel.org/r/20261020110732.959552-1-shawnq1@163.com
Fixes: b4c2bea8ceaa ("add listmount(2) syscall")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261021-work-mount-statmount_listns_fixes-v1-3-8917a4c1bd14@kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 6c9c0cdbe890e..dd60123a0cb0c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -6253,6 +6253,8 @@ static ssize_t do_listmount(struct klistmount *kls, bool reverse)
 	} else {
 		if (reverse)
 			first = mnt_find_id_at_reverse(ns, last_mnt_id - 1);
+		else if (last_mnt_id == U64_MAX)
+			first = NULL; /* nothing comes after the largest id */
 		else
 			first = mnt_find_id_at(ns, last_mnt_id + 1);
 	}
-- 
2.53.0



