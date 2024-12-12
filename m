Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFC622332E;
	Thu, 12 Dec 2024 17:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025889; cv=none; b=d4Vwz0xPfCEE3LyO80VXOwsM/OMjNnOKDlbLUo8MqrK7hsvIgNdEH407FvdAaVE9mwbYkBRurCwqBcjUEoZfmtwsS/2r1ekkOwE8F/S1QSgiXYqjDeEpultegGfNy7Vvyu26coTI20T9Nbn3cCgR7bWdndruAh0jQKCJkfO9fGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025889; c=relaxed/simple;
	bh=bbh/KXSOtB7WvPTetuNw4pZBiTWf3BR3SnnXne6N3lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dlNlVOvJs0uHkX76APyydm1iZ5Js9PvmMnygCTWQQY2i5hQlx81W3tdTEcMkYPVar84Z/Mj3Ed8+ozFZE9uHMlMlHBaWgM7UzUNoNmqfFYmYiOjLT78PcwY3gzpe5dcef3T6nP/FYpM+TF1oZ/MykSYQXmd5B1ZkVtC5MbUGvqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSdrkRIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSdrkRIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FCAC4CECE;
	Thu, 12 Dec 2024 17:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025886;
	bh=bbh/KXSOtB7WvPTetuNw4pZBiTWf3BR3SnnXne6N3lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSdrkRIrEloUNS6GeRbUX5RrdXSvqitAM6nXoJI8Ws5NDxHNql67ThNdcbqDKJwjL
	 f9lA0x1LKBBSRTmNKACEhv0onzbzaF0377csXySp+s4UKF9LHmv4CWp4QUlqjGRIMR
	 OMgwBNiponUBqzjcfQSRxOmQVFKKvYGFVhTByYrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
	Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.4 321/321] bpf, xdp: Update devmap comments to reflect napi/rcu usage
Date: Thu, 12 Dec 2024 16:03:59 +0100
Message-ID: <20241212144242.661090523@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

From: John Fastabend <john.fastabend@gmail.com>

commit 42a84a8cd0ff0cbff5a4595e1304c4567a30267d upstream.

Now that we rely on synchronize_rcu and call_rcu waiting to
exit perempt-disable regions (NAPI) lets update the comments
to reflect this.

Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/1580084042-11598-2-git-send-email-john.fastabend@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/devmap.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -210,10 +210,12 @@ static void dev_map_free(struct bpf_map
 
 	/* At this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
 	 * so the programs (can be more than one that used this map) were
-	 * disconnected from events. Wait for outstanding critical sections in
-	 * these programs to complete. The rcu critical section only guarantees
-	 * no further reads against netdev_map. It does __not__ ensure pending
-	 * flush operations (if any) are complete.
+	 * disconnected from events. The following synchronize_rcu() guarantees
+	 * both rcu read critical sections complete and waits for
+	 * preempt-disable regions (NAPI being the relevant context here) so we
+	 * are certain there will be no further reads against the netdev_map and
+	 * all flush operations are complete. Flush operations can only be done
+	 * from NAPI context for this reason.
 	 */
 
 	spin_lock(&dev_map_lock);
@@ -518,12 +520,11 @@ static int dev_map_delete_elem(struct bp
 		return -EINVAL;
 
 	/* Use call_rcu() here to ensure any rcu critical sections have
-	 * completed, but this does not guarantee a flush has happened
-	 * yet. Because driver side rcu_read_lock/unlock only protects the
-	 * running XDP program. However, for pending flush operations the
-	 * dev and ctx are stored in another per cpu map. And additionally,
-	 * the driver tear down ensures all soft irqs are complete before
-	 * removing the net device in the case of dev_put equals zero.
+	 * completed as well as any flush operations because call_rcu
+	 * will wait for preempt-disable region to complete, NAPI in this
+	 * context.  And additionally, the driver tear down ensures all
+	 * soft irqs are complete before removing the net device in the
+	 * case of dev_put equals zero.
 	 */
 	old_dev = xchg(&dtab->netdev_map[k], NULL);
 	if (old_dev)


