Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213606;
	b=iXXUhUxKUT/vymnci/2ozKRXD03NfSewQtvXFE0Nk5rCpekLiljoDi5+z6yWpKSE78D5
	 nL/lK1FEMw2fegv0e4m5YnePpJ1si0xeTC991asHmzZcquyV+ZaTklGw+6ClMiM9LHQ1M
	 f3HfU+jgxAGZ1C0loD1+jA4MTR/j+dRFsrPhm6lv9P6rLRbfs6boa55DQyq1imJDMKLSH
	 dbwEnoy/iCAKoV8JHT+9UFfdoRjUnaiTrPw8LP5AEoKtiG9lPcVaO7qQkWGY4jWx47LTx
	 1RB1jrNkJuET/5SOS8p3VCHjhWV1M/5lqouW095+ZveqU7NETvAqv8b+zTHioGZhhfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qo1LTaiDX1AiC2GQIo+6LltU+ztWALeL9WufDhjl1sU=;
	b=49lvgkbV4KRSFUL2EjGbUN/EjFw63aqUyTNHfVZfdqbM/ir5f1jKkcFlE1Agd/9QV8SK
	 w3H8/yTTLdG97i/bUfnrziQZq8GjBYsg8EGchgF7jJQ8oKHUfotRn2E6xehpi6VxG0izU
	 PEJu18lYEII5CxDdfLEI7L1wwod+PhI4bTTUK929MJSaWUJMiPNKkZnoXQkUhc1sAFen9
	 cfkwv86P1Fgi9g6EeREwtUCrl4VG/6Yf9nVXfCtL5WA8iKUMKwLyNYvZuTGoarU4qRaUZ
	 xCyOs0R3gRmN8bcfTDa1P7dHfDxqw+CA/Y3HWrSeZu5zzwnWuBUJwNGHqoNC1VLqVuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfycmkLT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4480E606A31A;
	Wed, 28 Oct 2026 18:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfycmkLT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E45F1F01825;
	Wed, 28 Oct 2026 18:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213605;
	bh=Qo1LTaiDX1AiC2GQIo+6LltU+ztWALeL9WufDhjl1sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfycmkLTxvbpy0kIz7LxVrD87MhZ16HJ2M6AMEQWAn6KkYCEGy9sfJkesRc48rrxK
	 d9SwPOLgc2zSR64JPieUx0P7SLG+FNbVj8k/MqzJcXdXov+6nbRkR3Y87/kwNjMsk2
	 mJzxQhXysQ2TPSbvjddQeNKPUFt+ern1O8VfKa1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0564/1887] coresight: Fix memory leak in acpi_buffer->pointer
Date: Wed, 28 Oct 2026 17:44:20 +0100
Message-ID: <20261028170512.227106160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Junhao He <hejunhao3@huawei.com>

[ Upstream commit 1a9e02673e2550f5612099e64e8761f0c8fc0f50 ]

There are memory leaks reported by kmemleak:
...
unreferenced object 0xffff00213c141000 (size 1024):
  comm "systemd-udevd", pid 2123, jiffies 4294909467 (age 6062.160s)
  hex dump (first 32 bytes):
    04 00 00 00 02 00 00 00 18 10 14 3c 21 00 ff ff  ...........<!...
    00 00 00 00 00 00 00 00 03 00 00 00 10 00 00 00  ................
  backtrace:
    [<000000004b7c9001>] __kmem_cache_alloc_node+0x2f8/0x348
    [<00000000b0fc7ceb>] __kmalloc+0x58/0x108
    [<0000000064ff4695>] acpi_os_allocate+0x2c/0x68
    [<000000007d57d116>] acpi_ut_initialize_buffer+0x54/0xe0
    [<0000000024583908>] acpi_evaluate_object+0x388/0x438
    [<0000000017b2e72b>] acpi_evaluate_object_typed+0xe8/0x240
    [<000000005df0eac2>] coresight_get_platform_data+0x1b4/0x988 [coresight]
...

The ACPI buffer memory (buf.pointer) should be freed. But the buffer
is also used after returning from acpi_get_dsd_graph().
Move the temporary variables buf to acpi_coresight_parse_graph(),
and free it before the function return to prevent memory leak.

Fixes: 76ffa5ab5b79 ("coresight: Support for ACPI bindings")
Signed-off-by: Junhao He <hejunhao3@huawei.com>
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20230817085937.55590-2-hejunhao3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hwtracing/coresight/coresight-platform.c  | 48 ++++++++++++-------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-platform.c b/drivers/hwtracing/coresight/coresight-platform.c
index 3f82ae07a18e5..f19e6758ce599 100644
--- a/drivers/hwtracing/coresight/coresight-platform.c
+++ b/drivers/hwtracing/coresight/coresight-platform.c
@@ -520,19 +520,18 @@ static inline bool acpi_validate_dsd_graph(const union acpi_object *graph)
 
 /* acpi_get_dsd_graph	- Find the _DSD Graph property for the given device. */
 static const union acpi_object *
-acpi_get_dsd_graph(struct acpi_device *adev)
+acpi_get_dsd_graph(struct acpi_device *adev, struct acpi_buffer *buf)
 {
 	int i;
-	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER };
 	acpi_status status;
 	const union acpi_object *dsd;
 
 	status = acpi_evaluate_object_typed(adev->handle, "_DSD", NULL,
-					    &buf, ACPI_TYPE_PACKAGE);
+					    buf, ACPI_TYPE_PACKAGE);
 	if (ACPI_FAILURE(status))
 		return NULL;
 
-	dsd = buf.pointer;
+	dsd = buf->pointer;
 
 	/*
 	 * _DSD property consists tuples { Prop_UUID, Package() }
@@ -583,12 +582,12 @@ acpi_validate_coresight_graph(const union acpi_object *cs_graph)
  * returns NULL.
  */
 static const union acpi_object *
-acpi_get_coresight_graph(struct acpi_device *adev)
+acpi_get_coresight_graph(struct acpi_device *adev, struct acpi_buffer *buf)
 {
 	const union acpi_object *graph_list, *graph;
 	int i, nr_graphs;
 
-	graph_list = acpi_get_dsd_graph(adev);
+	graph_list = acpi_get_dsd_graph(adev, buf);
 	if (!graph_list)
 		return graph_list;
 
@@ -688,18 +687,22 @@ static int acpi_coresight_parse_link(struct acpi_device *adev,
 static int acpi_coresight_parse_graph(struct acpi_device *adev,
 				      struct coresight_platform_data *pdata)
 {
-	int rc, i, nlinks;
+	int rc = 0;
+	int i, nlinks;
 	const union acpi_object *graph;
 	struct coresight_connection *conns, *ptr;
+	struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
 
 	pdata->nr_inport = pdata->nr_outport = 0;
-	graph = acpi_get_coresight_graph(adev);
-	if (!graph)
-		return -ENOENT;
+	graph = acpi_get_coresight_graph(adev, &buf);
+	if (!graph) {
+		rc = -ENOENT;
+		goto free;
+	}
 
 	nlinks = graph->package.elements[2].integer.value;
 	if (!nlinks)
-		return 0;
+		goto free;
 
 	/*
 	 * To avoid scanning the table twice (once for finding the number of
@@ -708,16 +711,20 @@ static int acpi_coresight_parse_graph(struct acpi_device *adev,
 	 * it to the pdata.
 	 */
 	conns = devm_kcalloc(&adev->dev, nlinks, sizeof(*conns), GFP_KERNEL);
-	if (!conns)
-		return -ENOMEM;
+	if (!conns) {
+		rc = -ENOMEM;
+		goto free;
+	}
 	ptr = conns;
 	for (i = 0; i < nlinks; i++) {
 		const union acpi_object *link = &graph->package.elements[3 + i];
 		int dir;
 
 		dir = acpi_coresight_parse_link(adev, link, ptr);
-		if (dir < 0)
-			return dir;
+		if (dir < 0) {
+			rc = dir;
+			goto free;
+		}
 
 		if (dir == ACPI_CORESIGHT_LINK_MASTER) {
 			if (ptr->outport >= pdata->nr_outport)
@@ -739,7 +746,7 @@ static int acpi_coresight_parse_graph(struct acpi_device *adev,
 
 	rc = coresight_alloc_conns(&adev->dev, pdata);
 	if (rc)
-		return rc;
+		goto free;
 
 	/* Copy the connection information to the final location */
 	for (i = 0; conns + i < ptr; i++) {
@@ -751,7 +758,14 @@ static int acpi_coresight_parse_graph(struct acpi_device *adev,
 	}
 
 	devm_kfree(&adev->dev, conns);
-	return 0;
+free:
+	/*
+	 * When ACPI fails to alloc a buffer, it will free the buffer
+	 * created via ACPI_ALLOCATE_BUFFER and set to NULL.
+	 * ACPI_FREE can handle NULL pointers, so free it directly.
+	 */
+	ACPI_FREE(buf.pointer);
+	return rc;
 }
 
 /*
-- 
2.53.0



