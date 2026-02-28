Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E46379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302116; cv=none; b=o6BLwam1AZ/BMqox7U71xdODnA4xYJD+qZ3m2Gu6dc4mhq3O6EaqyAtRZHgDPZSIsaYiBQ8K/oIWUs7lOm7J7RkeGAqCKN/KHnYuhpAYShYR0inNmG7MLOmI+MW/95iSA0wIpyZpQSOeMB0qOg5fNuUHIpgqZNWmHlhCCxx/B94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302116; c=relaxed/simple;
	bh=78O2xxmUjRXvFm7BygBQ6mUbIDDWE4R79nY+Tb0rmnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPftPlqUvK0u230pcuiKux272HJoUt+KoOflLFoB5DKo62HLHOB4f5nCOX8VVilFIebs8XowXuoemBWz0Lpho/12DtC7wGH5mpgxE14nL0ODTamCKMKzUKv5BeT9FKzvS/ipmONDF89nE5TsT1qfCDC2KNuTYtpS5fatrgBkFQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P8mz1dFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P8mz1dFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF57C116D0;
	Sat, 28 Feb 2026 18:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302115;
	bh=78O2xxmUjRXvFm7BygBQ6mUbIDDWE4R79nY+Tb0rmnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P8mz1dFnCUBRWBzm3189pjDEK1AIQzo8M77weE2eczu7MYuRp0dHPCDEMAwfMqpL4
	 Q0aekHtyCBXORfIEUzmI9OxwWHD+PQjBihovUV2CwXs9KH1GIlaICqLxX0veoVAz16
	 iJ88zw2t7mXnsFbeZNH4TLeeSj2aBi2u1B2Ci3tQVXRFPiexYyjenfZaMlA2CL56sU
	 OcVpddGp8RpU4H7jS70b27ojHjZZ8WnkMDwxMsy78IcygOYxc38uygiL+ErKklIUrp
	 F+6lXdt2bLMnVgj8AvMo6qa2TvoF4GxpzNxo9kY31scxQEiI/Re0nbFb+1/+s1Ibur
	 o/ved05CW4+xQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vincent Donnefort <vdonnefort@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/283] Documentation: tracing: Add ring-buffer mapping
Date: Sat, 28 Feb 2026 13:04:07 -0500
Message-ID: <20260228180709.1583486-105-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit a1e0dd7ce38af3fb1a3bc54a222a7c5e4eaa4202 ]

It is now possible to mmap() a ring-buffer to stream its content. Add
some documentation and a code example.

Link: https://lore.kernel.org/linux-trace-kernel/20240510140435.3550353-5-vdonnefort@google.com

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 8236fc613d44 ("Documentation: tracing: Add PCI tracepoint documentation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/index.rst           |   1 +
 Documentation/trace/ring-buffer-map.rst | 106 ++++++++++++++++++++++++
 2 files changed, 107 insertions(+)
 create mode 100644 Documentation/trace/ring-buffer-map.rst

diff --git a/Documentation/trace/index.rst b/Documentation/trace/index.rst
index 5092d6c13af5e..0b300901fd750 100644
--- a/Documentation/trace/index.rst
+++ b/Documentation/trace/index.rst
@@ -29,6 +29,7 @@ Linux Tracing Technologies
    timerlat-tracer
    intel_th
    ring-buffer-design
+   ring-buffer-map
    stm
    sys-t
    coresight/index
diff --git a/Documentation/trace/ring-buffer-map.rst b/Documentation/trace/ring-buffer-map.rst
new file mode 100644
index 0000000000000..8e296bcc0d7f3
--- /dev/null
+++ b/Documentation/trace/ring-buffer-map.rst
@@ -0,0 +1,106 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================================
+Tracefs ring-buffer memory mapping
+==================================
+
+:Author: Vincent Donnefort <vdonnefort@google.com>
+
+Overview
+========
+Tracefs ring-buffer memory map provides an efficient method to stream data
+as no memory copy is necessary. The application mapping the ring-buffer becomes
+then a consumer for that ring-buffer, in a similar fashion to trace_pipe.
+
+Memory mapping setup
+====================
+The mapping works with a mmap() of the trace_pipe_raw interface.
+
+The first system page of the mapping contains ring-buffer statistics and
+description. It is referred to as the meta-page. One of the most important
+fields of the meta-page is the reader. It contains the sub-buffer ID which can
+be safely read by the mapper (see ring-buffer-design.rst).
+
+The meta-page is followed by all the sub-buffers, ordered by ascending ID. It is
+therefore effortless to know where the reader starts in the mapping:
+
+.. code-block:: c
+
+        reader_id = meta->reader->id;
+        reader_offset = meta->meta_page_size + reader_id * meta->subbuf_size;
+
+When the application is done with the current reader, it can get a new one using
+the trace_pipe_raw ioctl() TRACE_MMAP_IOCTL_GET_READER. This ioctl also updates
+the meta-page fields.
+
+Limitations
+===========
+When a mapping is in place on a Tracefs ring-buffer, it is not possible to
+either resize it (either by increasing the entire size of the ring-buffer or
+each subbuf). It is also not possible to use snapshot and causes splice to copy
+the ring buffer data instead of using the copyless swap from the ring buffer.
+
+Concurrent readers (either another application mapping that ring-buffer or the
+kernel with trace_pipe) are allowed but not recommended. They will compete for
+the ring-buffer and the output is unpredictable, just like concurrent readers on
+trace_pipe would be.
+
+Example
+=======
+
+.. code-block:: c
+
+        #include <fcntl.h>
+        #include <stdio.h>
+        #include <stdlib.h>
+        #include <unistd.h>
+
+        #include <linux/trace_mmap.h>
+
+        #include <sys/mman.h>
+        #include <sys/ioctl.h>
+
+        #define TRACE_PIPE_RAW "/sys/kernel/tracing/per_cpu/cpu0/trace_pipe_raw"
+
+        int main(void)
+        {
+                int page_size = getpagesize(), fd, reader_id;
+                unsigned long meta_len, data_len;
+                struct trace_buffer_meta *meta;
+                void *map, *reader, *data;
+
+                fd = open(TRACE_PIPE_RAW, O_RDONLY | O_NONBLOCK);
+                if (fd < 0)
+                        exit(EXIT_FAILURE);
+
+                map = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
+                if (map == MAP_FAILED)
+                        exit(EXIT_FAILURE);
+
+                meta = (struct trace_buffer_meta *)map;
+                meta_len = meta->meta_page_size;
+
+                printf("entries:        %llu\n", meta->entries);
+                printf("overrun:        %llu\n", meta->overrun);
+                printf("read:           %llu\n", meta->read);
+                printf("nr_subbufs:     %u\n", meta->nr_subbufs);
+
+                data_len = meta->subbuf_size * meta->nr_subbufs;
+                data = mmap(NULL, data_len, PROT_READ, MAP_SHARED, fd, meta_len);
+                if (data == MAP_FAILED)
+                        exit(EXIT_FAILURE);
+
+                if (ioctl(fd, TRACE_MMAP_IOCTL_GET_READER) < 0)
+                        exit(EXIT_FAILURE);
+
+                reader_id = meta->reader.id;
+                reader = data + meta->subbuf_size * reader_id;
+
+                printf("Current reader address: %p\n", reader);
+
+                munmap(data, data_len);
+                munmap(meta, meta_len);
+                close (fd);
+
+                return 0;
+        }
-- 
2.51.0

