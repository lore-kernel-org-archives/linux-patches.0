Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061148;
	b=EGcXx9uDFNpu19lATcZXYjr7PTCWa1EjpxAh1pftZdFYHnii784gaDTfctk3QEBw+AlU
	 nb1s0CIkKJziCrqgN8fmqFuLUzQp2zauQL0YJRNc9AxV0wRSHkZOFN524Zkt99FgczrsB
	 /NU1zvPr3yw+DY+260m24QrZdEyWSls9lMIDcVUDLqCtAYoNKXsWb4U2/mtzKVMSoXNGx
	 DHUWcLsoIApKlQEgv0nKw/b7u57ep1kB98u7Amo8Q/W6dnkPze+X4FAIROq5KwGAjmKT5
	 7OhO5VYfpdL71NRN4uJt9k/p6Y49/2U0u3jiUeDmvkLHCEgHEuFeZpoHNl8JmMahisw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=38UH4t5/mYOaCNy8Nqr/wyylKCVQ0DyCXmMKbU2TwOE=;
	b=Fm4pZm3HTzhDivaEsIPr13H2g/qSTI9bl8AGV7LGqG78LjDgpUzgbXG0X7aP7P6HF9PA
	 X+i3a5M9Hc08JKipMAQwCQMBTuN2COQ8iNBEg0NqYo0z+sBSr0aas2pU7k+PGr+llO/W8
	 aFtN55CQlwIMVk0u496J8NGk/z0GM16mOgnFKNca5gHUBuppKXaIQxKqiEzs69TvZW2UB
	 PSveY7O/tanKyeRifQmSQDHQpH+R2s80fQjBTpvimvFX51l3uX5xms2PQAlClPrCD0h7w
	 mrfCaml1ceJg65CXPNPa0OVeaf2g8H4top21yclxOySFTnl39lYxrVsJKER0zwtCKMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTYrgkWW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A621606A326;
	Thu, 19 Nov 2026 04:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTYrgkWW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BF91F000C4;
	Thu, 19 Nov 2026 04:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061148;
	bh=38UH4t5/mYOaCNy8Nqr/wyylKCVQ0DyCXmMKbU2TwOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTYrgkWWrkrONyWU1dAUBivxGsna7yNj0dYhU+/tddshY+cLL4hAXqkAD9N7S9V1f
	 cgxi95m2evdkwRqxQD+ZJvXwbq1yBcqAKo7tRNFgQsPDYfmyYLhckGBH01VawUGNnP
	 ILiaAZ3FVZP/+ICPAFdpS+1+mV3XXujB6/HmDabA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1448/1848] md: take reconfig_mutex when enabling PPL on an inactive array
Date: Wed, 18 Nov 2026 15:58:06 +0100
Message-ID: <20261118150020.054886112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit 900bf42e0ff8009f66ffd4a679c56264957019dd ]

consistency_policy_store() sets MD_HAS_PPL for an external-metadata array
that is not running yet, without holding reconfig_mutex.  But ->pers is
only assigned after pers->run() returns, so "not running" also covers an
md_run() that is in progress under the lock.

If the write lands inside raid5_run() after log_init() has decided not to
set up PPL, or after a failed ppl_init_log() has cleared the flag, the
flag ends up set with conf->log_private still NULL.  The next idle pass
of raid5d() then does:

  raid5d() -> handle_active_stripes() -> log_flush_stripe_to_raid()
    -> ppl_write_stripe_run()

and dereferences the NULL ppl_conf:

  Oops: general protection fault, probably for non-canonical address
  0xdffffc0000000002
  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
  RIP: 0010:ppl_write_stripe_run+0x60/0x1320 drivers/md/raid5-ppl.c:538

Take reconfig_mutex around the update and refuse it with -EBUSY once the
array is running, in which case ->change_consistency_policy() is the
right interface.

Fixes: 664aed04446c ("md: add sysfs entries for PPL")
Reported-by: syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=75d7e96ad03ac2dbbd9f
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Link: https://patch.msgid.link/20260924171345.75894-1-ngocthang2710.1999@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ed528f3c778ef..35add0ecc2c59 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5474,7 +5474,15 @@ consistency_policy_store(struct mddev *mddev, const char *buf, size_t len)
 		else
 			err = -EBUSY;
 	} else if (mddev->external && strncmp(buf, "ppl", 3) == 0) {
-		set_bit(MD_HAS_PPL, &mddev->flags);
+		/* md_run() holds the lock until ->pers is set */
+		err = mddev_lock(mddev);
+		if (err)
+			return err;
+		if (mddev->pers)
+			err = -EBUSY;
+		else
+			set_bit(MD_HAS_PPL, &mddev->flags);
+		mddev_unlock(mddev);
 	} else {
 		err = -EINVAL;
 	}
-- 
2.53.0



