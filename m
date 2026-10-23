Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774817;
	b=VRrhxeQf0CUZZIvkT9x72ngwuPxG8uh8nYyXPHpvUNgGgyS89m/QJ/FudEYBpFw2n59+
	 wA4vyGq/BQy7roDhYaYegkq1Vx6NKLDyqmWED5DlCKy45ca9zbpMniUdcTYnFPP2UrkSB
	 EMMU9Fll2rku91uGjW1d8yxphuAYwczejDdpAqQ5uhqohHhqbO9hYWsPPAROYnbDo67jb
	 5udxKr7G5zPhzZ+b7iyDl/60RdeIVTy9k0ZmJy/UcpZ/KL2IGbe4QoLZYBzsOBY7/Yylj
	 YJ3faxBwPpl2OR4+M8ZR+impbXp44rZ+Cjyller6k78tRrQ+90B/1KVG8WCU/CPpWUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774817;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rp/8fQ7RmjUP2nqnBoUOYjUoiM1v/VnE1VgKAgTIypI=;
	b=snDzdB+jQxCIofovm2ik6vIA2trc3+3ErGrAEfOiARilBS+zAtz8m8hWpD6Yj/4nO9r8
	 +6byvth9G/OReQAeWe9LmvdNIFSRw1jTYnmULaG6aokw1IWy/XGFwPMeCyon1GLTDmebE
	 A1Usjgxbq4BAR0VvYsj6FjHWpTXUqHAFmwt27IXZEf1fxNX7Rf2ARWcqHblIcc55lJPtb
	 HQBGKc2Olsit1uCRUWQP0DMU3GgvlXZxqm6FUhJX7lD/MU5M8d11wbN8uVM0iODnPwTnY
	 EkNBLSm6UJSs7gZz2AEMDzWVl33VwJoVad/DdpUKpK9GY5WwIzWrZ2gUe9BOM09xCHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NcnueJ7C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0113606A31A;
	Fri, 23 Oct 2026 17:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NcnueJ7C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1321F01825;
	Fri, 23 Oct 2026 17:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774816;
	bh=rp/8fQ7RmjUP2nqnBoUOYjUoiM1v/VnE1VgKAgTIypI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NcnueJ7CAkTdy7P3L+niMXpE91Gu2ra7A/ZMprc5iXjMtXSrOG2ocy2gsqw8tftWo
	 wSBvveFyVpDmqtzaNEq8bjDJPi0tlA9hvjekiiZTSDb6F89Ic9eJ9cdNMdxJ0TDXWU
	 JRhd7pi0UfaA7JC+FGipI6ieo7T79TRyMQCRi80o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Len Brown <len.brown@intel.com>
Subject: [PATCH 7.2 131/242] tools/power turbostat: Read complete CPU lists
Date: Fri, 23 Oct 2026 18:39:33 +0200
Message-ID: <20261023163716.880071622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

commit c24362650f7a8573dc9a9991a034b8500af8eb19 upstream.

CPU_SUBSET_MAXCPUS accepts CPU IDs through 8191, but the sysfs and
cgroup CPU-list readers stop at 1024 bytes. A fragmented cpuset or
hybrid PMU CPU list can exceed that size and be truncated.
initialize_cpu_set_from_sysfs() can also pass a full, non-NUL-terminated
buffer to parse_cpu_str(), causing an out-of-bounds read.

Additionally, initialize_cpu_set_from_sysfs() returns with the file
still open on success. It is now called once per CPU for
thread_siblings_list, so large systems can leak thousands of descriptors
during topology discovery.

Use getline() so both readers receive a complete, NUL-terminated line.
Close and free the sysfs CPU-list resources on every path, and report
malformed input from the correct buffer.

Fixes: eb187540d13a ("tools/power turbostat: Increase CPU_SUBSET_MAXCPUS to 8192")
Fixes: 58839fdbd441 ("tools/power turbostat: Process HT siblings in CPU order")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/power/x86/turbostat/turbostat.c |   44 +++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 19 deletions(-)

--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -6316,33 +6316,35 @@ int for_all_proc_cpus(int (func) (int))
 
 #define PATH_EFFECTIVE_CPUS	"/sys/fs/cgroup/cpuset.cpus.effective"
 
-static char cpu_effective_str[1024];
+static char *cpu_effective_str;
 
 static int update_effective_str(bool startup)
 {
 	FILE *fp;
-	char *pos;
-	char buf[1024];
+	char *buf = NULL;
+	size_t size = 0;
 	int ret;
 
-	if (cpu_effective_str[0] == '\0' && !startup)
+	if (!cpu_effective_str && !startup)
 		return 0;
 
 	fp = fopen(PATH_EFFECTIVE_CPUS, "r");
 	if (!fp)
 		return 0;
 
-	pos = fgets(buf, 1024, fp);
-	if (!pos)
+	if (getline(&buf, &size, fp) < 0)
 		err(1, "%s: file read failed", PATH_EFFECTIVE_CPUS);
 
 	fclose(fp);
 
-	ret = strncmp(cpu_effective_str, buf, 1024);
-	if (!ret)
+	ret = cpu_effective_str ? strcmp(cpu_effective_str, buf) : 1;
+	if (!ret) {
+		free(buf);
 		return 0;
+	}
 
-	strncpy(cpu_effective_str, buf, 1024);
+	free(cpu_effective_str);
+	cpu_effective_str = buf;
 	return 1;
 }
 
@@ -8534,13 +8536,16 @@ end:
 	return ret;
 }
 
-char cpuset_buf[1024];
-int initialize_cpu_set_from_sysfs(cpu_set_t *cpu_set, char *sysfs_path, char *sysfs_file)
+int initialize_cpu_set_from_sysfs(cpu_set_t *cpu_set, const char *sysfs_path,
+				  const char *sysfs_file)
 {
 	FILE *fp;
+	char *cpuset_buf = NULL;
+	size_t size = 0;
 	char path[128];
+	int ret = -1;
 
-	if (snprintf(path, 128, "%s/%s", sysfs_path, sysfs_file) > 128)
+	if (snprintf(path, sizeof(path), "%s/%s", sysfs_path, sysfs_file) >= (int)sizeof(path))
 		err(-1, "%s %s", sysfs_path, sysfs_file);
 
 	fp = fopen(path, "r");
@@ -8548,19 +8553,20 @@ int initialize_cpu_set_from_sysfs(cpu_se
 		warn("open %s", path);
 		return -1;
 	}
-	if (fread(cpuset_buf, sizeof(char), 1024, fp) == 0) {
+	if (getline(&cpuset_buf, &size, fp) < 0) {
 		warn("read %s", sysfs_path);
-		goto err;
+		goto out;
 	}
 	if (parse_cpu_str(cpuset_buf, cpu_set, cpu_possible_setsize)) {
-		warnx("%s: cpu str malformat %s\n", sysfs_path, cpu_effective_str);
-		goto err;
+		warnx("%s: cpu str malformat %s\n", sysfs_path, cpuset_buf);
+		goto out;
 	}
-	return 0;
+	ret = 0;
 
-err:
+out:
 	fclose(fp);
-	return -1;
+	free(cpuset_buf);
+	return ret;
 }
 
 void print_cpu_set(char *s, cpu_set_t *set)


