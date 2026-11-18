Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030691;
	b=MyzHl8d4Vp5udN/NHhEUGC2agwyFX0s2YyjmW4JO/dzycN0sai/kZ25GzbbWiMMYsHnH
	 xkFcjCbtrKm1afRyq6LCu8EgKSqQQC3aRCCzga8vk3ure/tf7L1J0vJjqHq1cHFf8g1iL
	 4YTM9IX3/EetZ87HVINDhKprwVT9cniDDmLmnGceIVDnv+9ou6u45ESI6vB5++hipxKZZ
	 zC6dNPAYbPktet1skjj+m+KBYiNPXe/jjqllf3EaY8Qtk9niCEBb6NzBq+QHweuiPq75N
	 SSK1l1javz5BY6LAGFdFzjnTqwYb8fAxwZi5gjx8yBATIwQ1tdFKn/8RVZ1FYgxezAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=31Ij3fyMPqsD0cT/4lRlzQ3Ez1v4E2RNQxeOmDD937E=;
	b=vNGn/l5R0YvTXj7VvdpKo9OzNThOnycnWHZ9YYlPA0meC81MZAQ/A8lseQOS6J5TZ65g
	 2duyGDFhvXHU1IExieMYzp3nV9HLzujr1pUh0jhq7Jr2C9nVEjEQIjeZ156dOdklqAFYQ
	 YhNGJRAJuDc690SenaFlGg5xPM5Yj14fwfA6fshZimQGUEOzfnwk5zFUh2ujM55+/lNUv
	 YlTUi/xFMlyTweolSrBz9TXq3eokEVVyOqT60/8uOzfsV7mJSRwqpN/Rbw/ivY0AeEqww
	 kfXRvIRnv0YxhjrD/n/fmWxPERrvHim2ZnCbBhanTIksPrepb6sR+cQQ+ZdLzZlM8wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bvIeD/dO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE40606A7F4;
	Wed, 18 Nov 2026 19:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bvIeD/dO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A36D1F000C4;
	Wed, 18 Nov 2026 19:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030691;
	bh=31Ij3fyMPqsD0cT/4lRlzQ3Ez1v4E2RNQxeOmDD937E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvIeD/dOuXsBf1ooVqofuX3pLA4W02HDnHqaGEuDLua3Kjq+/rqUoeMotcMzz7/F/
	 tR6DLoRo0OUU0lkcwVJWLWQ8xQ3EphmV631ovUDn6dD97xmL/DNBZekBqFNncQUJo8
	 89ZzxVGbPGMtIye/9xVm037Wwrw6D8EZakO+02vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0742/1756] perf trace: Copy sockaddr arguments by their length
Date: Wed, 18 Nov 2026 15:47:49 +0100
Message-ID: <20261118150039.142727750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 1c443dfc3202048b2cb1d3c2534b39b28701e929 ]

The BTF augmenter copies sizeof(struct sockaddr), 16 bytes, for the
sockaddr arguments of connect, bind and sendto, and runs before the
sys_enter_connect and sys_enter_sendto programs that copy their length.
An IPv6 address needs 24 or 28 bytes, so the rest was read from past the
payload, and now that the printers are bounded only its family is shown.

Copy them as buffers sized by the length argument after them, up to the
32 bytes augmented buffers are limited to. That holds an IPv6 address
and doubles the AF_LOCAL path shown.

Committer testing:

Is using BPF:

  root@x2:~# strace -e bpf perf trace -e connect,bind |& head -5
  bpf(BPF_TOKEN_CREATE, {token_create={flags=0, bpffs_fd=12}}, 8) = -1 EOPNOTSUPP (Operation not supported)
  bpf(BPF_PROG_LOAD, {prog_type=BPF_PROG_TYPE_SOCKET_FILTER, insn_cnt=2, insns=0x7ffea3054260, license="GPL", log_level=0, log_size=0, log_buf=NULL, kern_version=KERNEL_VERSION(0, 0, 0), prog_flags=0, prog_name="", prog_ifindex=0, expected_attach_type=BPF_CGROUP_INET_INGRESS, prog_btf_fd=0, func_info_rec_size=0, func_info=NULL, func_info_cnt=0, line_info_rec_size=0, line_info=NULL, line_info_cnt=0, attach_btf_id=0, attach_prog_fd=0, core_relo_cnt=0, fd_array=NULL, core_relos=NULL, core_relo_rec_size=0, log_true_size=0, prog_token_fd=0}, 148) = 12
  bpf(BPF_PROG_LOAD, {prog_type=BPF_PROG_TYPE_SOCKET_FILTER, insn_cnt=2, insns=0x7ffea3054390, license="GPL", log_level=0, log_size=0, log_buf=NULL, kern_version=KERNEL_VERSION(0, 0, 0), prog_flags=0, prog_name="", prog_ifindex=0, expected_attach_type=BPF_CGROUP_INET_INGRESS, prog_btf_fd=0, func_info_rec_size=0, func_info=NULL, func_info_cnt=0, line_info_rec_size=0, line_info=NULL, line_info_cnt=0, attach_btf_id=0, attach_prog_fd=0, core_relo_cnt=0, fd_array=NULL, core_relos=NULL, core_relo_rec_size=0, log_true_size=0, prog_token_fd=0, fd_array_cnt=0, signature=NULL, signature_size=0, keyring_id=0}, 168) = 12
  bpf(BPF_PROG_LOAD, {prog_type=BPF_PROG_TYPE_SOCKET_FILTER, insn_cnt=2, insns=0x7ffea3053f80, license="GPL", log_level=0, log_size=0, log_buf=NULL, kern_version=KERNEL_VERSION(0, 0, 0), prog_flags=0, prog_name="libbpf_nametest", prog_ifindex=0, expected_attach_type=BPF_CGROUP_INET_INGRESS, prog_btf_fd=0, func_info_rec_size=0, func_info=NULL, func_info_cnt=0, line_info_rec_size=0, line_info=NULL, line_info_cnt=0, attach_btf_id=0, attach_prog_fd=0, core_relo_cnt=0, fd_array=NULL, core_relos=NULL, core_relo_rec_size=0, log_true_size=0, prog_token_fd=0}, 148) = 12
  bpf(BPF_MAP_CREATE, {map_type=BPF_MAP_TYPE_ARRAY, key_size=4, value_size=4, max_entries=1, map_flags=BPF_F_MMAPABLE, inner_map_fd=0, map_name="libbpf_mmap", map_ifindex=0, btf_fd=0, btf_key_type_id=0, btf_value_type_id=0, btf_vmlinux_value_type_id=0, map_extra=0, value_type_btf_obj_fd=0, map_token_fd=0, excl_prog_hash=NULL, excl_prog_hash_size=0}, 92) = 12
  root@x2:~#

And btf:

  root@x2:~# strace -e openat perf trace -e connect,bind |& grep "/sys/kernel/btf/vmlinux"
  openat(AT_FDCWD, "/sys/kernel/btf/vmlinux", O_RDONLY) = 12
  ^C
  root@x2:~#

And copying the sockaddr parameters according to its addrlen or the cap
in the augmented bpf, that probably needs to be a bit bigger for local
sockets:

  ⬢ [acme@toolbx perf-tools-next]$ echo -n /var/run/.heim_org.h5l.kcm-soc | wc -c
  30
  ⬢ [acme@toolbx perf-tools-next]$ ls -la /var/run/.heim_org.h5l.kcm-socket
  srw-rw-rw-. 1 nobody nobody 0 Sep 14 23:13 /var/run/.heim_org.h5l.kcm-socket
  ⬢ [acme@toolbx perf-tools-next]$

  root@x2:~# perf trace -e connect,bind --max-events 10
       0.000 ( 0.717 ms): pool-0/29901 connect(fd: 9, uservaddr: { .family: LOCAL, path: /var/run/.heim_org.h5l.kcm-soc }, addrlen: 110) = 0
       3.733 ( 0.059 ms): pool-0/29901 connect(fd: 10, uservaddr: { .family: LOCAL, path: /var/run/.heim_org.h5l.kcm-soc }, addrlen: 110) = 0
       8.859 ( 0.054 ms): pool-0/29901 connect(fd: 9, uservaddr: { .family: LOCAL, path: /var/run/.heim_org.h5l.kcm-soc }, addrlen: 110) = 0
      10.880 ( 0.053 ms): pool-0/29901 connect(fd: 9, uservaddr: { .family: LOCAL, path: /var/run/.heim_org.h5l.kcm-soc }, addrlen: 110) = 0
    1225.303 ( 0.081 ms): systemd-resolv/103685 connect(fd: 30, uservaddr: { .family: INET6, port: 53, addr: fd55:6f31:c26b::1, scope_id: 4 }, addrlen: 28) = 0
    1226.000 ( 0.046 ms): systemd-resolv/103685 connect(fd: 31, uservaddr: { .family: INET6, port: 53, addr: fd55:6f31:c26b::1, scope_id: 4 }, addrlen: 28) = 0
    1371.972 ( 0.055 ms): systemd-resolv/103685 connect(fd: 27, uservaddr: { .family: INET6, port: 53, addr: fd55:6f31:c26b::1, scope_id: 4 }, addrlen: 28) = 0
    1382.266 ( 0.260 ms): Socket Thread/2663038 connect(fd: 178, uservaddr: { .family: INET, port: 443, addr: 186.192.83.34 }, addrlen: 16) = -1 (unknown) (Operation now in progress)
    5003.508 ( 0.063 ms): pool-0/29901 connect(fd: 9, uservaddr: { .family: LOCAL, path: /var/run/.heim_org.h5l.kcm-soc }, addrlen: 110) = 0
    5007.007 ( 0.054 ms): pool-0/29901 connect(fd: 10, uservaddr: { .family: LOCAL, path: /var/run/.heim_org.h5l.kcm-soc }, addrlen: 110) = 0
  root@x2:~#

Fixes: a68fd6a6cdd309bb ("perf trace: Collect augmented data using BPF")
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 983dbe1bda935..11b5e26bbdeb1 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -3770,7 +3770,12 @@ static int trace__bpf_sys_enter_beauty_map(struct trace *trace, int key, unsigne
 				continue;
 
 			bt = sc->arg_fmt[i].type;
-			beauty_array[i] = bt->size;
+			/* Copy a sockaddr as a buffer sized by the next argument, e.g. addrlen. */
+			if (strcmp(name, "sockaddr") == 0 && field->next &&
+			    strstr(field->next->name, "len"))
+				beauty_array[i] = -((i + 1) + 1);
+			else
+				beauty_array[i] = bt->size;
 			can_augment = true;
 		} else if (field->flags & TEP_FIELD_IS_POINTER && /* string */
 			   strcmp(field->type, "const char *") == 0 &&
-- 
2.53.0



