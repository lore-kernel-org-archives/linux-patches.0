Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016743;
	b=ufwwQc9V7kg/E6ydp0vR3x5uITNNYu4/4HCxFcO0vgYclfc2a8m+I5L5vbD7mC33/G8n
	 FvRhzIVlYSWEPXBIxthEX6EY2WWPo06uI2mXDIgt23i2JTaDILwDI+Fu3uMoH080L1UOW
	 5ozocp1qACe9kKmV/iyPqeW8miHlCfwgEG+kqS9PXhNKQrhwry82VDwfxBWyKcI9REaDd
	 fJqJvKWEXbDZNBNqzwyQ6Uc7S9saJeA4aLtvYuhRS19HkpYso4pXvy2hjQdwq0f1ZaYN9
	 LhVmqcY2te5wYuLdVnNsPou8Zi3hXH4gWXpXJDL8BVLD4FMXw3LfZaXvUNQiDW5326A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nuuiYF893+7br/jA4K3EEBqP+UYxNNEhDDkAtqb0ptw=;
	b=kZozLuB3oCLvijzLtEFEIUO6A8sSuiCK5rJ44KhEM3UWyGKRjKof9MPNCNw7+L5e4dpd
	 toSAxKz4Qo5o8fNqFAhQe62NribL8FBfBG5a7sPsfF1/T5hK6Xs5jskQJW8takuaEGVa5
	 bRKe0/XvP/MK5mbi6Aq0rvw/9VtF0XCe6ZDcpb0xdvBzExFnjgJMRr2DzaWLnroMz3Shp
	 QH/E6HhMQOIaSk6YrPTU3ElFLIN2BSHZR7MucndVlgUni3ztA5eIqvicDRyhXooOchzH1
	 4vNyGzUmwoRERUihTu1it48+vLN4OTd6hzf+QqkAEcTW0uWRosfANaiAvbll6hozO8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=02eEtQql;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C220606A31C;
	Wed, 18 Nov 2026 15:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=02eEtQql
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10811F000C4;
	Wed, 18 Nov 2026 15:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016743;
	bh=nuuiYF893+7br/jA4K3EEBqP+UYxNNEhDDkAtqb0ptw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=02eEtQqlsMTXB0HPNubRx1VssZAKHU7xYxEtBlHrm36LrSm3Km0POP6WCoSz6dDK8
	 mr4KJ+LeZOlDTnZEEzUG+nifgyW6rrFnjgiyJau6emV/6JPW6HId+5QdPnNRh6B8FF
	 fN4VKlGkYy4DAP/T28fIzluB/4pH1WIjFoLGeQ18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0636/2651] selftests/coredump: discard the right amount after the coredump request
Date: Wed, 18 Nov 2026 15:31:16 +0100
Message-ID: <20261118150310.581956691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

[ Upstream commit 73337f1ac1379e31cc37868e5a61e4202f095a88 ]

read_coredump_req() gets the leftover wrong twice.

It takes the absolute difference of the two sizes, so a test binary that
knows a larger struct coredump_req than the kernel sends tries to discard
bytes that were never sent. And it hands recv() sizeof(buffer) instead of
the number of bytes it wants. So MSG_WAITALL waits for a whole page.
Either one blocks until the kernel closes the socket. Which it won't
because it is waiting for the coredump ack...

It's benign today because struct coredump_req hasn't grown. But let's fix
it for the future. Compute the leftover as what the kernel sent beyond
what was consumed.

Fixes: 59cd658eaf40 ("selftests/coredump: add coredump server selftests")
Link: https://patch.msgid.link/20260820-work-coredump-sparse-v2-4-ba32dd718c51@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/coredump/coredump_test_helpers.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index 2a20faf9cb0ad..524fa5370593a 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -235,10 +235,10 @@ bool read_coredump_req(int fd, struct coredump_req *req)
 	fprintf(stderr, "Read coredump request with size %u and mask 0x%llx\n",
 		req->size, (unsigned long long)req->mask);
 
-	if (user_size > kernel_size)
-		remaining_size = user_size - kernel_size;
-	else
+	if (kernel_size > user_size)
 		remaining_size = kernel_size - user_size;
+	else
+		remaining_size = 0;
 
 	if (PAGE_SIZE <= remaining_size)
 		return false;
@@ -250,7 +250,7 @@ bool read_coredump_req(int fd, struct coredump_req *req)
 	if (remaining_size) {
 		char buffer[PAGE_SIZE];
 
-		ret = recv(fd, buffer, sizeof(buffer), MSG_WAITALL);
+		ret = recv(fd, buffer, remaining_size, MSG_WAITALL);
 		if (ret != remaining_size)
 			return false;
 		fprintf(stderr, "Discarded %zu bytes of data after coredump request\n", remaining_size);
-- 
2.53.0



