Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212840;
	b=1j6KvZKH5lNFON0gWmLc0Y2JEMHn71J5RKf9GbrUmpVv3pSp41xq5mUirg8Cm1YOG4dq
	 ecXyTOIfusxHEuriiUNN2HjqF9Y3Z8SmnvKmWwTmIFjdWn7ySyuKmmvee611+M1jXkvDY
	 lR1mcPzb94QGz4E/+KntMjAOSHjt57XteJNz7mwUSOHQVwp91dPEeqn53NcHVQoDaV4vW
	 PCWe9MUUfN3BRn4uVE/YdFDWy6inS62qDEWkY+OjLPeeNEbuY0zkeZSuMH36vaaGdtNy1
	 Upikpp0OdQu5mYu1kJ7+SPmbmpsQXjEKZtynUzNWs7R3kFVhlOyiLuvfnmniMCwBsVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VNLIcBhRIu1bPwJcsiELutP1C67F7HxTvrBs8zzZRL0=;
	b=C/Rj2tQxTDzselFfN37E3br9gT24szJFvgOFA0tKwhyqzASLmP04M3CM9ikSyYgYf3yw
	 WDj7KMHVSgoQVUY+d2Aqtg+M0Pk/ziCJIVtAIP+4IxtgLTTqWZlThWeWf5tb1DkeC7KtO
	 Ph9k4gieC0S7GzBKb+pc4qAF8731WzaCoWHPvhyWqOODfJswfHrfrqHIV/FQ3rReNJV4W
	 WH+33p999/8bFdwrb8E0M8Y6n2jt5gWTyEkSBJZ4TrpDh3Rphbu/oP/i16ZBCGUpFoJUd
	 6bcL6v1Dk07G7W8wCdckDMwdWzG0Ni8wo5gZxOJU4hYMJWt+syAfhXe2nJJWnBy7fdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wWDytau5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB78606A321;
	Wed, 28 Oct 2026 18:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wWDytau5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE3E1F01825;
	Wed, 28 Oct 2026 18:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212840;
	bh=VNLIcBhRIu1bPwJcsiELutP1C67F7HxTvrBs8zzZRL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wWDytau5H5s7vY5ubideoHyjxxjNOxfR93gRkNjkGLuJEeQMcgO/15kR00OzV0Hil
	 OMhsKFQnfkttDUJDdmGwSpO5Kglxjg4YJz30S6axiK1GBPJHOXiT7fCbn/uC9p4V5Q
	 ajybppdCp50usCEHul5WpCF0SRozYos0+/o4JygQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Subject: [PATCH 6.1 0293/1887] tty: serial: qcom_geni_serial: Keep console RX functional after deep idle
Date: Wed, 28 Oct 2026 17:39:49 +0100
Message-ID: <20261028170505.898594070@linuxfoundation.org>
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

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

commit 63ef71d1474b5417b5b2dec700cd251c44a570d9 upstream.

At baud rates up to 115200, the serial console uses only a 1 kBps keepalive
vote for the GENI_TO_CORE ("qup-core") ICC path. This vote keeps the path
active but does not request a QUP Core 2X clock rate.

When the CPU enters a deeper idle state, the missing Core clock vote can
leave the console RX path unresponsive.

Use the 19.2 MHz Core 2X vote at low baud rates, while retaining the 50 MHz
vote at higher baud rates, so that console RX remains functional after deep
idle transitions.

Fixes: 7cf563b2c846 ("tty: serial: qcom_geni_serial: Add interconnect support")
Cc: stable@kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-correct-icc-bandwidth-vote-constants-v2-2-f78eb611204e@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1056,9 +1056,8 @@ static void qcom_geni_serial_set_termios
 	 * Bump up BW vote on CPU and CORE path as driver supports FIFO mode
 	 * only.
 	 */
-	avg_bw_core = (baud > 115200) ? Bps_to_icc(CORE_2X_50_MHZ)
-						: GENI_DEFAULT_BW;
-	port->se.icc_paths[GENI_TO_CORE].avg_bw = avg_bw_core;
+	avg_bw_core = baud > 115200 ? CORE_2X_50_MHZ : CORE_2X_19_2_MHZ;
+	port->se.icc_paths[GENI_TO_CORE].avg_bw = Bps_to_icc(avg_bw_core);
 	port->se.icc_paths[CPU_TO_GENI].avg_bw = Bps_to_icc(baud);
 	geni_icc_set_bw(&port->se);
 


