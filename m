Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620531;
	b=G3B4IMUtgAD8yNDYWbZ7JiAd+jNXj/puOX0k4kARJLTiOdNfTWZSgi8lRlXVI4j+NWb+
	 5efX/U4wnBEkct+YLn39gXJM/rM5ODNWOurKLKqtgkoITeFxRAGJAv6wn9Dd/8BdsgbcS
	 ou/hhCiEA2Hr9U/Zv3iFhkYVDmoIdkK2MCrSc3paSUUYbDWMYMUVhnccTbhIWqMpQ+qmR
	 HXwlMPLMi13WCU4i34qOXXfETLOtdjah9YodsJySaKCp7q1knS1wToR7E1i59xtSZYAiw
	 vZzBYk7kkl/CGzNeq10nmKvmblck02ePK5zMejPuK4K0Q018M5gSMriZW8sg6UXStlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620531;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1cTFUWlp7qX1wAhXtHhQRsuOd5zcve3A3JPlu+/LuOc=;
	b=yiG4t9z76abwSZv3YMjWffKfZQOk/+bJivnhzaI0ZvxiBD43S/bOF5OvgM2kC5Dzhk0l
	 IZ5SHxjjrTQywiSHxF8u0adOiccfMytcTVj2vx5NX+WfOJOIv4/rr5Z3mB4q+5TB1nTxk
	 xvDJcJsMGxcKCTW3DGcGaOqYmQJTxH1VDDwCh8+wRh1z1yxEV+IWgNsl1nlPG7xt9ue3j
	 ICYoLRblxcqzO87voev00QqkstEfiaBr2pv1uv/lfrVEp7Xnyms90x6BlGvov2u29LVYS
	 A75kgO92GaR4ou15RB3hXCZWfVJvOuaMNvTEScvwB3TazrEZHzTF2+REEf4vzoLOx6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N7mCF66L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FAF606A326;
	Wed, 25 Nov 2026 15:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N7mCF66L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5521F000C6;
	Wed, 25 Nov 2026 15:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620530;
	bh=1cTFUWlp7qX1wAhXtHhQRsuOd5zcve3A3JPlu+/LuOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7mCF66LmE0DeuLGTcnKfI+mQgRZph5D2XkqPkXjLeUqyZOhbuZspoXNrb5LRqPfW
	 qyut/Azw+XLSZY4R22r3277jlLizlmYOz0eT/V/5gP8X6UKJqK2J3olqo9eNkIQdHg
	 J3PTSwy/bD5SuyGNYnoX5JxhB/pPsc/KfMrkoU+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 7.3 0949/1005] w1: use the bus mutex for the "rw" file
Date: Wed, 25 Nov 2026 15:38:07 +0100
Message-ID: <20261125143843.906366070@linuxfoundation.org>
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

commit 8599e08648c0b4913ea7b202511f1294d176e793 upstream.

Commit b02f8bede217 ("W1: split master mutex to avoid deadlocks.") gave
the bus a mutex of its own, because the lock which protects the list of
slaves is held while a slave is removed, which waits for the sysfs
callbacks of the slave, so these must not take it.  It converted all the
slave drivers, but not the "rw" file of the default family in w1.c,
which still takes the mutex of the master to talk on the bus.  That has
two consequences:

- A deadlock.  w1_process() holds the mutex of the master while it
  searches the bus and detaches the slaves which have gone:

    w1_process()                        read() of .../rw
      mutex_lock(&dev->mutex)             kernfs active reference
      w1_search_process()                 rw_read()
        w1_slave_detach()                   mutex_lock(&master->mutex)
          w1_unref_slave()                    waits
            device_unregister()
              waits for the reference

  The file is readable for everybody.

- The accesses through this file are not serialised with those of the
  slave drivers, which take bus_mutex, so that two transactions can get
  mixed up on the wire.

Take bus_mutex here as well.  It also excludes the search, which takes it
for every pass.

Fixes: b02f8bede217 ("W1: split master mutex to avoid deadlocks.")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-w1-v1-1-d2e6bfafb6a4@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/w1.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -116,7 +116,7 @@ static ssize_t rw_write(struct file *fil
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 	if (w1_reset_select_slave(sl)) {
 		count = 0;
 		goto out_up;
@@ -125,7 +125,7 @@ static ssize_t rw_write(struct file *fil
 	w1_write_block(sl->master, buf, count);
 
 out_up:
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 	return count;
 }
 
@@ -135,9 +135,9 @@ static ssize_t rw_read(struct file *filp
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&sl->master->bus_mutex);
 	w1_read_block(sl->master, buf, count);
-	mutex_unlock(&sl->master->mutex);
+	mutex_unlock(&sl->master->bus_mutex);
 	return count;
 }
 


