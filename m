Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620524;
	b=PLx3EH7on6m+nGdC23l2JtuGKWmQiDRydOy2NPYR6aDL+SM2qpWyvfhddJs2qQlyWuqe
	 o8RigpskkOdLSIy7FPLDrQ/4gUS09OGG3iMmqmLykVeSnL+FE9dGtuojHTkYs3hHH205/
	 3VIfOKK7HF2pGK/f0UaEgolzC4J49waNxGjcK8Xxde9iERAJspo8p6RVtqrh0WibJ0sdy
	 UGZ5a09zLmXAPcG0dke/cL5cTIZ3YtrY8W4zVP41k/ar91cJmypMuLUFjOvPFQcyrpovA
	 8wSaBgGi6jBN7TUqgXINUgpwIDDqc1zQ5z82PSsTlgQMgYPU0pOAeH/kRxW5bgGZkXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CBaEVVgeRrszXoMyDzSRnN+OY14fOMFXdY4MW8Eh4aM=;
	b=RzZmERmXjt2kIah0uuKwuC+ZfMHryAQNnBfs/uzCoj9cqnaUngqLPgKNWoWGOu81WIBo
	 AUDVvVynZyRVZtYDyDDg1v7yz49jHnPYxK+cx4v4wG0OohMrBqbPFJbIYCdSR+tiBX2JV
	 yFIVnbiqZvOfALY9aIXRFV8EGblHVvn51GEPYMX4E5kaFznBSwoAdLTwNW+WlzOtMEC4T
	 8iGEnNXM49GzX8GmXnOFFeCAxkVUlF8OGlYZTvQqyeWX4O4RU/HXUi3U0HZz1yYMEWnQN
	 I1JRwwqUOvXEaE4nyZx0gRMHGPNq1o2k/HbaVhy75mFzdyKssTJqpQMQXPqFoTCq7DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AEPpT31u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3116E606A33C;
	Wed, 25 Nov 2026 15:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AEPpT31u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A8C1F000D8;
	Wed, 25 Nov 2026 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620524;
	bh=CBaEVVgeRrszXoMyDzSRnN+OY14fOMFXdY4MW8Eh4aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AEPpT31uLQebvBkJRmyLJq/Quxg9YYP3l853zl9zTZPiNUHRuQb3mpM7JkQLUG5cd
	 Ffleh9TEhOENym6vHyxAtWA9+RIUKzaC+Q6RlFIudANZhwyJxjjwG8NojR7B0Fb0Fs
	 iywAWHQxbzADH1Y7fUSDFf2t435Y/8bAGzBlD2GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 7.3 0947/1005] w1: netlink: drop the slave after the bus is unlocked
Date: Wed, 25 Nov 2026 15:38:05 +0100
Message-ID: <20261125143843.861073463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 847fa880a3e1b2fdbbf72d89e830566108457637 upstream.

w1_process_cb() executes the commands of a netlink message with bus_mutex
held, and drops the reference to the slave which the message was
addressed to before it unlocks the mutex.  If the slave has been detached
in the meantime, this is the last reference, and w1_unref_slave() tears
the slave down on the spot.  That waits

- in device_unregister(), for the sysfs callbacks of the slave which are
  running, and

- in w1_therm_remove_slave(), for the readers which have taken a
  reference to the family data,

and both kinds take bus_mutex to talk to the slave.  Whoever is waiting
for the mutex at that moment is never going to finish, and neither is the
thread of the bus master.

Unlock the bus first.  The reference keeps the slave, and with it the
master, alive until then.

Fixes: d3a8a9dbb903 ("w1: hold bus_mutex in netlink and search")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-w1-v1-6-d2e6bfafb6a4@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/w1_netlink.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -478,15 +478,17 @@ static void w1_process_cb(struct w1_mast
 	if (!cmd || err)
 		w1_netlink_queue_status(node->block, node->msg, cmd, err);
 
+	dev->priv = NULL;
+	mutex_unlock(&dev->bus_mutex);
+
 	/* ref taken in w1_search_slave or w1_search_master_id when building
-	 * the block
+	 * the block.  If it is the last one, the slave is removed, which waits
+	 * for users of the bus.
 	 */
 	if (sl)
 		w1_unref_slave(sl);
 	else
 		atomic_dec(&dev->refcnt);
-	dev->priv = NULL;
-	mutex_unlock(&dev->bus_mutex);
 
 	mutex_lock(&dev->list_mutex);
 	list_del(&async_cmd->async_entry);


