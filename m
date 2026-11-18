Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044223;
	b=5DIY1IYHnnioShMklGxFYGrhWWojmEOQCwSd685SBxFb2oY+2I3VfHp4P++wmJahPHY0
	 ZS3F7DO1bDDA0wCJ0A6oW69GyajgjNsKSSRKVJPSCqMPGt//NrVbg1L/tj+X70yvW5svH
	 3PqjHpFcfsxkDIct/8lKhvqKp9Dfl7I/FkGxPVr31DUk3UXG5h2j/Gj67YrIFmnJkC4sk
	 4nXalP+5L03bq0C8SQvtkmpwfpNk6mWQzJed1qgm3h/31/s9Zc3RP1x7HCOlEQ+Mk3Sin
	 NX/x4AK/R5MC0D0JthaRznNo6XM1Ok2JXP3o2aIhjJumbLighsoDc2rGqjwsqOxg0Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JXxaFx4De6vDSQj9CFLCY6yUl7jEYS01kgQfgoS3M0I=;
	b=a8bnrUJCOtKWbZmRHF3mBVVxo+og09b3wGXfKeDexeexaFVuUAABYaZYl2BapB/jtGKY
	 LGYyUibN4uDdC5P171kYwcqOrbR8bhCc95xiqXHGUtXe1N/2+3OEeK1Qn81poD81CKF9z
	 i/s22WP+RMgb19QrpagZLn1jl4WWZkTjRBffAifmS6nPI4H21qtjgD+W7guvufhqpwJ4R
	 NfK2AEyKFOZXjdtt3K0d3oNkwLmvJtdFDQ5HNJ/gDtXW/1W2keZPwImdXoS1d/mCVUUcU
	 54Ytm+Tutpl2jsZce/n5yDYAUChCEx3TBJHa9fvwUlEjJGj+G6DGIFQJ6hcE3RjLZxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+ElMvZ4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6074606A325;
	Wed, 18 Nov 2026 23:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+ElMvZ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5087D1F000C4;
	Wed, 18 Nov 2026 23:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044222;
	bh=JXxaFx4De6vDSQj9CFLCY6yUl7jEYS01kgQfgoS3M0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+ElMvZ4rlPHyELegvqdCQmyNDlwSwSbe2a4OkcYbMUmZ9XrT2mc0ZS0ODGadGd6q
	 QWBGXeso3l6ro6GINv5kBb5uh8M1q1I9ugsl2dzhXy+hmGR6hj8fzwz1yMn6yq6usG
	 O3q8IyvIp5AeCBW8HN7nb/pKWCaSyHT6AaKPPI14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Kulikov <vlad_kulikov_c@pm.me>,
	Jan Kara <jack@suse.cz>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Ma Wupeng <mawupeng1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0491/2857] ipc: create_ipc_ns: drop mqueue mount on sysctl setup failure
Date: Wed, 18 Nov 2026 15:25:25 +0100
Message-ID: <20261118150219.133291386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Kulikov <vlad.kulikov.c@gmail.com>

[ Upstream commit 7229d74e5e8c1f140529d405c88d4493e37ce4e3 ]

If setup_mq_sysctls(ns) fails after mq_init_ns(ns) succeeds, the error
path skipped releasing the internal kernel mqueue mount kept in
ns->mq_mnt. That leaves the vfsmount/superblock referenced until final
namespace teardown, i.e. a resource leak on this rare failure edge.

Unwind it by calling mntput(ns->mq_mnt) before dropping user_ns and
freeing the IPC namespace. This mirrors the normal ordering used in
free_ipc_ns().

Link: https://lkml.kernel.org/r/20251021181341.670297-1-vlad_kulikov_c@pm.me
Signed-off-by: Vlad Kulikov <vlad_kulikov_c@pm.me>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ma Wupeng <mawupeng1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: f0e48172a59e ("ipc: drop the mqueue mount with kern_unmount() on setup failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/namespace.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/ipc/namespace.c b/ipc/namespace.c
index 3075ca4920f1a..745826c9206bc 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -61,10 +61,10 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 
 	err = -ENOMEM;
 	if (!setup_mq_sysctls(ns))
-		goto fail_put;
+		goto fail_mq_mount;
 
 	if (!setup_ipc_sysctls(ns))
-		goto fail_mq;
+		goto fail_mq_sysctls;
 
 	err = msg_init_ns(ns);
 	if (err)
@@ -77,9 +77,10 @@ static struct ipc_namespace *create_ipc_ns(struct user_namespace *user_ns,
 
 fail_ipc:
 	retire_ipc_sysctls(ns);
-fail_mq:
+fail_mq_sysctls:
 	retire_mq_sysctls(ns);
-
+fail_mq_mount:
+	mntput(ns->mq_mnt);
 fail_put:
 	put_user_ns(ns->user_ns);
 	ns_free_inum(&ns->ns);
-- 
2.53.0



