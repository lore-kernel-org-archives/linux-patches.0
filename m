Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619616;
	b=ZaSH3SAlMx0DS5lV9WUz+ruSXbjPnJi0okSkBu5LsT7T6dr5hNiIVnDb55tyyUW5bBC+
	 sC9PGwH5b4G6fMGHOaG2gXXtCAGASzXI/OXBeIYi+6/0Z++TCUAhv98+8eWFq5vZXER05
	 dJb7hlXBspb31THYrckHCqtylcMvJG5auWgtobNY0bnBUTWSSFpLrcXwtLlbTvSargHyD
	 gaug+TsuRJHOWU5qcP+cT76tVorpeAq8tVZZqmEFehVkEzPJtjjUDhdEIbbLiM1EPZaum
	 Ds3eXBcGQMWt/04cNrWudruXU4/6B4AmDme2DcET6HAkl2DhFcfXGPTuRh1ClFgLglw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Km1o7Kfhca/zo3aEWO7IeVYIuhDIN6CdZnWFXDMRLRY=;
	b=zVqSSh51eLViEKnDT3mq8lv1DFViIb6yydKI6zliAX1AfNIg11CW+gKTIy2saYRM0fnH
	 jKo286reMbCezGFH/IEEvqAgUZsA4n0l6WwcttX+5ZYF48N/ErW7XzfBciRiN+Rgx18ym
	 CFUky+ChZPt9jxRy35oIhSsEXEt97/EdQX8O602wiXpaXprcolOzNOWkA49U2elqMiDzj
	 HD4X78YVm8oqGzEscdFx9AueGl8zz9hp9zoNWA12otrKx3b9Tp6uPxmQeOFw4HANicptU
	 j1Pg6aewgIL1WnokZpwqoVAAId6b+9CxAK8M/WE0oMk5GrCd+MM/VmSZouZa39qnnFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iIns4DPX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C745606A329;
	Wed, 25 Nov 2026 15:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iIns4DPX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B906B1F000C4;
	Wed, 25 Nov 2026 15:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619616;
	bh=Km1o7Kfhca/zo3aEWO7IeVYIuhDIN6CdZnWFXDMRLRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iIns4DPXk/SMH0i1J7Ui1G0jokc1EtXkZjghOUCfIpK67f2h6MIhXja8lGblz2ngP
	 4+2J1EFOh0tC4WHjecAp0RJlECq14cgeqihihfbJ04hH2/UxD2GIIr/DAH/7eLLek6
	 AG+Ub6JiATAbNpVokh6cb/IYLHAcAAwwablZUcW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0655/1005] hv_sock: Report no unread data before a channel is available
Date: Wed, 25 Nov 2026 15:33:13 +0100
Message-ID: <20261125143837.093041968@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

commit 71b06766b7c49ed5f489b8bd104f82ff164d67a3 upstream.

The Hyper-V transport is assigned before the asynchronous VMBus channel
offer completes.  Its zero-initialized hvsock therefore has a NULL chan
until hvs_open_connection() associates the channel with the socket.

SIOCINQ can query the assigned transport while the socket is connecting,
or after connect() fails once the transport has been assigned.  Unlike
poll(), that path does not check stream_is_active() before calling the
transport's stream_has_data callback.  hvs_stream_has_data() then passes
the NULL channel to hvs_channel_readable_payload(), and any user in the
guest can trigger an oops:

  BUG: kernel NULL pointer dereference, address: 0000000000000178
  RIP: 0010:hvs_stream_has_data+0x23/0x120
  Call Trace:
   <TASK>
   ? vsock_ioctl+0x74/0xf0
   sock_do_ioctl+0x42/0xf0
   sock_ioctl+0x27d/0x310
   do_vfs_ioctl+0x700/0x810
   __x64_sys_ioctl+0x7d/0xf0

Return zero unread bytes when no channel is available, before accessing
the receive state or ring.  Leave the existing channel-backed receive
handling unchanged.

The oops was reproduced on an unmodified v7.4-rc1 kernel in a WSL2
guest with a small user-space program, available on request.  With this
patch, the program reports zero unread bytes and the kernel logs nothing.
Other vsock_test cases were not run, as most of them need a host-side
peer.

AI assistance was used to identify the issue and develop the fix.

Fixes: f7c722659275 ("vsock: Add support for SIOCINQ ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Link: https://patch.msgid.link/20261106123920.162131-1-parri.andrea@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/hyperv_transport.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -697,6 +697,9 @@ static s64 hvs_stream_has_data(struct vs
 	struct hvsock *hvs = vsk->trans;
 	s64 ret;
 
+	if (!hvs->chan)
+		return 0;
+
 	if (hvs->recv_data_len > 0)
 		return hvs->recv_data_len;
 


